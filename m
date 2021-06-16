Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1303AA4DF
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhFPUC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 16:02:27 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35090 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhFPUC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 16:02:27 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ltbhz-00ALKF-B8; Wed, 16 Jun 2021 14:00:19 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ltbhy-00GzYo-EL; Wed, 16 Jun 2021 14:00:18 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
        <87eeda7nqe.fsf@disp2133>
        <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
        <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
        <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
        <87y2bh4jg5.fsf@disp2133>
        <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
        <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
        <87pmwmn5m0.fsf@disp2133>
        <4163ed48afbcb1c288b366fe2745205cd66bea3d.camel@trillion01.com>
Date:   Wed, 16 Jun 2021 15:00:12 -0500
In-Reply-To: <4163ed48afbcb1c288b366fe2745205cd66bea3d.camel@trillion01.com>
        (Olivier Langlois's message of "Wed, 16 Jun 2021 15:23:14 -0400")
Message-ID: <87v96dd1gz.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1ltbhy-00GzYo-EL;;;mid=<87v96dd1gz.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/YHsuWebb9sYalsImH4bcCYfwK+jJ/HM8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Olivier Langlois <olivier@trillion01.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 362 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 11 (2.9%), b_tie_ro: 9 (2.6%), parse: 1.27 (0.4%),
         extract_message_metadata: 17 (4.7%), get_uri_detail_list: 1.04 (0.3%),
         tests_pri_-1000: 17 (4.7%), tests_pri_-950: 1.77 (0.5%),
        tests_pri_-900: 1.47 (0.4%), tests_pri_-90: 85 (23.4%), check_bayes:
        81 (22.3%), b_tokenize: 9 (2.4%), b_tok_get_all: 6 (1.6%),
        b_comp_prob: 2.4 (0.7%), b_tok_touch_all: 60 (16.7%), b_finish: 0.98
        (0.3%), tests_pri_0: 214 (59.0%), check_dkim_signature: 0.47 (0.1%),
        check_dkim_adsp: 2.5 (0.7%), poll_dns_idle: 0.47 (0.1%), tests_pri_10:
        2.3 (0.6%), tests_pri_500: 8 (2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Olivier Langlois <olivier@trillion01.com> writes:

> I redid my test but this time instead of dumping directly into a file,
> I did let the coredump be piped to the systemd coredump module and the
> coredump generation isn't working as expected when piping.
>
> So your code review conclusions are correct.

Thank you for confirming that.

Do you know how your test program is using io_uring?

I have been trying to put the pieces together on what io_uring is doing
that stops the coredump.  The fact that it takes a little while before
it kills the coredump is a little puzzling.  The code looks like all of
the io_uring operations should have been canceled before the coredump
starts.

Thanks,
Eric
