Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780A757BBD7
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 18:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiGTQuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiGTQuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 12:50:00 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D63966AE1;
        Wed, 20 Jul 2022 09:49:59 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:48622)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECta-00C3oD-4N; Wed, 20 Jul 2022 10:49:58 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:40080 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECtZ-002yu4-2v; Wed, 20 Jul 2022 10:49:57 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
        <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
        <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
        <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
        <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
        <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
        <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
        <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
Date:   Wed, 20 Jul 2022 11:49:31 -0500
In-Reply-To: <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk> (Jens Axboe's
        message of "Tue, 31 May 2022 21:15:57 -0600")
Message-ID: <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oECtZ-002yu4-2v;;;mid=<87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+dx3F0RDR9KXL38YfycHH+G0LWPESKF84=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 469 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 11 (2.3%), b_tie_ro: 9 (2.0%), parse: 0.87 (0.2%),
         extract_message_metadata: 2.4 (0.5%), get_uri_detail_list: 0.65
        (0.1%), tests_pri_-1000: 3.6 (0.8%), tests_pri_-950: 1.25 (0.3%),
        tests_pri_-900: 1.06 (0.2%), tests_pri_-90: 168 (35.7%), check_bayes:
        166 (35.4%), b_tokenize: 5 (1.1%), b_tok_get_all: 6 (1.3%),
        b_comp_prob: 2.0 (0.4%), b_tok_touch_all: 149 (31.7%), b_finish: 0.88
        (0.2%), tests_pri_0: 259 (55.2%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 2.9 (0.6%), poll_dns_idle: 1.18 (0.3%), tests_pri_10:
        3.5 (0.8%), tests_pri_500: 11 (2.3%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 0/2] coredump: Allow io_uring using apps to dump to pipes.
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



Folks who have been suffering from io_uring coredumping issues please
give this a spin.  I have lightly tested this version and more heavily
tested an earlier version which had more dependencies.

Unless I have missed something in cleaning up the code this should
be a comprehensive fix to the coredumping issues when using io_uring.

But folks please test and verify this.  It has taken me long enough to
get back to this point I don't properly remember how the reproducer I
have was supposed to fail.  All I can say with certainty is set of
changes has what looks like a positive effect.

Eric W. Biederman (2):
      signal: Move stopping for the coredump from do_exit into get_signal
      coredump: Allow coredumps to pipes to work with io_uring


 fs/coredump.c            | 30 ++++++++++++++++++++++++++++--
 include/linux/coredump.h |  2 ++
 kernel/exit.c            | 29 +++++------------------------
 kernel/signal.c          |  5 +++++
 mm/oom_kill.c            |  2 +-
 5 files changed, 41 insertions(+), 27 deletions(-)

Eric
