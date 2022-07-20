Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF79257BBF5
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 18:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiGTQvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 12:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiGTQvj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 12:51:39 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D598D675BB;
        Wed, 20 Jul 2022 09:51:35 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:54210)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECv8-00AUeC-Tm; Wed, 20 Jul 2022 10:51:34 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:40140 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECv7-002zG9-U8; Wed, 20 Jul 2022 10:51:34 -0600
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
        <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
Date:   Wed, 20 Jul 2022 11:51:27 -0500
In-Reply-To: <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Wed, 20 Jul 2022 11:49:31 -0500")
Message-ID: <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oECv7-002zG9-U8;;;mid=<87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+oGLq5krvvMrRh4NiQGwHlLaqBKb8Xk7Q=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 432 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.6 (1.1%), b_tie_ro: 3.2 (0.7%), parse: 1.20
        (0.3%), extract_message_metadata: 11 (2.6%), get_uri_detail_list: 2.1
        (0.5%), tests_pri_-1000: 10 (2.4%), tests_pri_-950: 1.01 (0.2%),
        tests_pri_-900: 0.78 (0.2%), tests_pri_-90: 93 (21.6%), check_bayes:
        91 (21.1%), b_tokenize: 6 (1.3%), b_tok_get_all: 8 (1.9%),
        b_comp_prob: 1.70 (0.4%), b_tok_touch_all: 73 (16.8%), b_finish: 0.82
        (0.2%), tests_pri_0: 296 (68.5%), check_dkim_signature: 0.41 (0.1%),
        check_dkim_adsp: 3.3 (0.8%), poll_dns_idle: 1.92 (0.4%), tests_pri_10:
        2.7 (0.6%), tests_pri_500: 8 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 2/2] coredump: Allow coredumps to pipes to work with io_uring
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Now that io_uring like everything else stops for coredumps in
get_signal the code can once again allow any interruptible
condition after coredump_wait to interrupt the coredump.

Clear TIF_NOTIFY_SIGNAL after coredump_wait, to guarantee that
anything that sets TIF_NOTIFY_SIGNAL before coredump_wait completed
won't cause the coredumps to interrupted.

With all of the other threads in the process stopped io_uring doesn't
call task_work_add on the thread running do_coredump.  Combined with
the clearing of TIF_NOTIFY_SIGNAL this allows processes that use
io_uring to coredump through pipes.

Restore dump_interrupted to be a simple call to signal_pending
effectively reverting commit 06af8679449d ("coredump: Limit what can
interrupt coredumps").  At this point only SIGKILL delivered to the
coredumping thread should be able to cause signal_pending to return
true.

A nice followup would be to find a reliable race free way to modify
task_work_add and probably set_notify_signal to skip setting
TIF_NOTIFY_SIGNAL once it is clear a task will no longer process
signals and other interruptible conditions.  That would allow
TIF_NOTIFY_SIGNAL to be cleared where TIF_SIGPENDING is cleared in
coredump_zap_process.

To be as certain as possible that this works, I tested this with
commit 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
reverted.  Which means that not only is TIF_NOTIFY_SIGNAL prevented
from stopping coredumps to pipes, the sequence of stopping threads to
participate in the coredump avoids deadlocks that were possible
previously.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 67dda77c500f..c06594f56cbb 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -476,7 +476,7 @@ static bool dump_interrupted(void)
 	 * but then we need to teach dump_write() to restart and clear
 	 * TIF_SIGPENDING.
 	 */
-	return fatal_signal_pending(current) || freezing(current);
+	return signal_pending(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)
@@ -589,6 +589,9 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
+	/* Don't break out of interruptible sleeps */
+	clear_notify_signal();
+
 	ispipe = format_corename(&cn, &cprm, &argv, &argc);
 
 	if (ispipe) {
-- 
2.35.3

