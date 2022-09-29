Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39CF5EF730
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 16:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbiI2OHr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 10:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiI2OHq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 10:07:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5DF1B2614
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 07:07:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id jo24so796306plb.13
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 07:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=YgqJYszIlI8pskjB/t57QE+szPDZKYoQV8TF2bbwEX8=;
        b=OrXT1SutETToYdv7j3df9XXvEfwHPS7WQIKr6y7scibKamgKrKdMEJRkXztP74PC7U
         0QqdgdDqGd9iG6sywEb+PW/Mw+AEbdjq0v991OuAW55f2b7+0Ynr44ioQY1ctfAu73cN
         0D8XUABOV7LgRRfygevpmTihBj1gy9lKCPht2g3g9XEd5i51eD66FSxhdeFVNhrO+Jne
         7LeU5g6vIGfDA+YadN+m8UYp+Ll8ejdw7dS5LRfBPRwXua8+TnAlMpotMEK61fb3QEUn
         eYe3XLyFHCQjRZVwPqt9dICAtbDfQJbfSK1w25l74J35PaiZiyVmc4vk796XoaUS8oVS
         dXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YgqJYszIlI8pskjB/t57QE+szPDZKYoQV8TF2bbwEX8=;
        b=2spD4VArwOMlQPQd1vmFjUgAvlsedMsnalCSQNmKiGoLKxCNdZ00+iFTbOkLIXIG0s
         EZYSnnyqLY/9lwDfCu/rC7xBrrD2prRsvraVR7a2zyOdsYcgFX2RR+JtKgNwBO0TiQ6+
         hffNWl7vLDDXdCFxHcujYQZ5MTDNRzRZM1oCvQ7YwxLYpsHlIt1YPQrGNGPWvymi75EM
         ac7T7MQogqk2W/cSL3/jdXK18ptCtORlhQfWZ76YPdPB9M4SLAeZcpLBW7tMAo+2h7UI
         Q3DjCwyMezp2bqbtHgky+LMxHAFPt5j/YHo4crSzrT4485K30hiuwwClm8LMQaxwfbWa
         g7XQ==
X-Gm-Message-State: ACrzQf10ZDwZEa044A5ICE9KpW9VKiq10PDel4spY99u3keBVBfNT15C
        I3S0Kz3UPvDLN7NV1/YgMTHIGw==
X-Google-Smtp-Source: AMsMyM6cvV2NYLkk14HdJM0NJuqN1eJDwLVwjJsC8krNuktzgpja/UQg8rGDA81BGLv6mrRWtqGYYA==
X-Received: by 2002:a17:903:248:b0:172:7520:db04 with SMTP id j8-20020a170903024800b001727520db04mr3708608plh.99.1664460461971;
        Thu, 29 Sep 2022 07:07:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090341cb00b00174d9bbeda4sm6060863ple.197.2022.09.29.07.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 07:07:41 -0700 (PDT)
Message-ID: <0f7a2712-5252-260c-3b0f-ec584e1066a3@kernel.dk>
Date:   Thu, 29 Sep 2022 08:07:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [syzbot] inconsistent lock state in kmem_cache_alloc
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>
Cc:     syzbot <syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mhiramat@kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Matthew Bobrowski <repnop@google.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
References: <00000000000074b50005e997178a@google.com>
 <edef9f69-4b29-4c00-8c1a-67c4b8f36af0@suse.cz>
 <20220929135627.ykivmdks2w5vzrwg@quack3>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220929135627.ykivmdks2w5vzrwg@quack3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/22 7:56 AM, Jan Kara wrote:
> On Thu 29-09-22 15:24:22, Vlastimil Babka wrote:
>> On 9/26/22 18:33, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    105a36f3694e Merge tag 'kbuild-fixes-v6.0-3' of git://git...
>>> git tree:       upstream
>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=152bf540880000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=dfcc5f4da15868df7d4d
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1020566c880000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104819e4880000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
>>
>> +CC more folks
>>
>> I'm not fully sure what this report means but I assume it's because there's
>> a GFP_KERNEL kmalloc() allocation from softirq context? Should it perhaps
>> use memalloc_nofs_save() at some well defined point?
> 
> Thanks for the CC. The problem really is that io_uring is calling into
> fsnotify_access() from softirq context. That isn't going to work. The
> allocation is just a tip of the iceberg. Fsnotify simply does not expect to
> be called from softirq context. All the dcache locks are not IRQ safe, it
> can even obtain some sleeping locks and call to userspace if there are
> suitable watches set up.
> 
> So either io_uring needs to postpone fsnotify calls to a workqueue or we
> need a way for io_uring code to tell iomap dio code that the completion
> needs to always happen from a workqueue (as it currently does for writes).
> Jens?

Something like this should probably work - I'll write a test case and
vet it.


diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1ae1e52ab4cb..a25cd44cd415 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -236,14 +236,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -270,6 +262,20 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 	return res;
 }
 
+static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+
+	io_req_task_complete(req, locked);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -278,7 +284,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	if (__io_complete_rw_common(req, res))
 		return;
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 

-- 
Jens Axboe
