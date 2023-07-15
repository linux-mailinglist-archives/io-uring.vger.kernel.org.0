Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B22754C05
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjGOUYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jul 2023 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjGOUYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jul 2023 16:24:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714E12718
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 13:24:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-682b1768a0bso795633b3a.0
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 13:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689452639; x=1692044639;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C5ipTEk38+I5oBx7wAgIhZddOYCjUGaNqRFhqSapiek=;
        b=mJ9RNhgdcgY6iizvRIySM7HDyaRC9d2F2pJJy5ae+6N9O5a1uSjXAyLPh2E/lUHMOi
         AcKAryYFkfJQIhR1LR7wrRnnz9PBea1HQHftWSBeUc884+A4/6WUjH03zaWAqExla86b
         aleLbwNQmabnq3rlRD4X9xP0UjQ3yYnQFynkEMUGv4XR49GkU0+2O6yHKmdAqlw3YoMX
         QAaH/2521yrQQfvUOiyafFzKEg0Fi0Mvak2lkDpi61jvyTXxdZBXCVztGiFWQuleWZCZ
         uJRvY4ZzUHYWpQqzLnn3OxP7cmwPgpkCmbyKQ2VYxNDJM6Y1ePEoXQn9ULjSQqhk6YRr
         pS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689452639; x=1692044639;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5ipTEk38+I5oBx7wAgIhZddOYCjUGaNqRFhqSapiek=;
        b=RIcm0JzIN/YDcAHmIMRc2ZCL1QZFdK0wkHtM4NxmwipUKMSiT29C2h1wQrzSg6PaRS
         q3Uclol6NPhEQS7vgVXVlsfoxr5oS308LUv2/3ToFHPF1CLJSjt8xKbxASLE2q3TZ3pr
         /dP6iHuFN5WuIIDeD+Hi8NMmaiW4dSY9cnoKUpgJf2Cp817tkTukPVpTsISDNw/8EkU5
         YNkPa0IpQn0XpIAwFGJBOWwLWxHaKYmZlji66SPNLoivxpboR3x1VwV7tHCSyTmmH0CA
         LanTvGOguxd98p9aialiXt5S6meqj60BW4i0HipmFAts9M2JDLRrKlcKWgsrxxpMSVXH
         S98A==
X-Gm-Message-State: ABy/qLYBU4DTjl9qbvUVs5ZLbSlKrYijIod5vv2cL1PDuU/JEC5i2+gg
        mmwpmlkUBklq6lP325pWQqJc+g==
X-Google-Smtp-Source: APBJJlG55zwJP6OYGCnLkqE+WoYQ0lerl7qrGDRdfAU/AaQCuna9efk20gFxwgD9xS11rWNSioMIbQ==
X-Received: by 2002:a05:6a20:4415:b0:134:76d5:d3fd with SMTP id ce21-20020a056a20441500b0013476d5d3fdmr909515pzb.0.1689452639549;
        Sat, 15 Jul 2023 13:23:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o17-20020a639211000000b00553ad4ae5e5sm9740941pgd.22.2023.07.15.13.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jul 2023 13:23:58 -0700 (PDT)
Message-ID: <f58c25ac-4179-06e5-4110-06982ae34d86@kernel.dk>
Date:   Sat, 15 Jul 2023 14:23:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
 <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
 <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
 <ca82bd8b-5868-8fbb-6701-061220a1ff97@kernel.dk>
 <57926544-3936-410f-ae0e-6eff266ea59c@app.fastmail.com>
 <509f35fc-72dc-8676-4e3a-6bbc8d7eefb4@kernel.dk>
In-Reply-To: <509f35fc-72dc-8676-4e3a-6bbc8d7eefb4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/23 8:06?AM, Jens Axboe wrote:
> On 7/15/23 1:12?AM, Arnd Bergmann wrote:
>> On Fri, Jul 14, 2023, at 22:14, Jens Axboe wrote:
>>> On 7/14/23 12:33?PM, Arnd Bergmann wrote:
>>>> On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
>>>>> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>>>>>>>> Does this require argument conversion for compat tasks?
>>>>>>>>
>>>>>>>> Even without the rusage argument, I think the siginfo
>>>>>>>> remains incompatible with 32-bit tasks, unfortunately.
>>>>>>>
>>>>>>> Hmm yes good point, if compat_siginfo and siginfo are different, then it
>>>>>>> does need handling for that. Would be a trivial addition, I'll make that
>>>>>>> change. Thanks Arnd!
>>>>>>
>>>>>> Should be fixed in the current version:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>>>>>
>>>>> In kernel/signal.c in pidfd_send_signal() we have
>>>>> copy_siginfo_from_user_any() it seems that a similar version
>>>>> copy_siginfo_to_user_any() might be something to consider. We do have
>>>>> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
>>>>> context why this wouldn't work here.
>>>>
>>>> We could add a copy_siginfo_to_user_any(), but I think open-coding
>>>> it is easier here, since the in_compat_syscall() check does not
>>>> work inside of the io_uring kernel thread, it has to be
>>>> "if (req->ctx->compat)" in order to match the wordsize of the task
>>>> that started the request.
>>>
>>> Yeah, unifying this stuff did cross my mind when adding another one.
>>> Which I think could still be done, you'd just need to pass in a 'compat'
>>> parameter similar to how it's done for iovec importing.
>>>
>>> But if it's ok with everybody I'd rather do that as a cleanup post this.
>>
>> Sure, keeping that separate seem best.
>>
>> Looking at what copy_siginfo_from_user_any() actually does, I don't
>> even think it's worth adapting copy_siginfo_to_user_any() for io_uring,
>> since it's already just a trivial wrapper, and adding another
>> argument would add more complexity overall than it saves.
> 
> Yeah, took a look too this morning, and not sure there's much to reduce
> here that would make it cleaner. I'm going to send out a v2 with this
> unchanged, holler if people disagree.

One thing we could do is the below, but honestly not sure it's worth the
hassle?


diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 14ffa07e161a..6de1041c4784 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -43,6 +43,8 @@ static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
 	bool ret;
 
 	infop = (struct compat_siginfo __user *) iw->infop;
+	if (!infop)
+		return true;
 
 	if (!user_write_access_begin(infop, sizeof(*infop)))
 		return false;
@@ -66,32 +68,13 @@ static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
 static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	bool ret;
-
-	if (!iw->infop)
-		return true;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		return io_waitid_compat_copy_si(iw, signo);
 #endif
 
-	if (!user_write_access_begin(iw->infop, sizeof(*iw->infop)))
-		return false;
-
-	unsafe_put_user(signo, &iw->infop->si_signo, Efault);
-	unsafe_put_user(0, &iw->infop->si_errno, Efault);
-	unsafe_put_user(iw->info.cause, &iw->infop->si_code, Efault);
-	unsafe_put_user(iw->info.pid, &iw->infop->si_pid, Efault);
-	unsafe_put_user(iw->info.uid, &iw->infop->si_uid, Efault);
-	unsafe_put_user(iw->info.status, &iw->infop->si_status, Efault);
-	ret = true;
-done:
-	user_write_access_end();
-	return ret;
-Efault:
-	ret = false;
-	goto done;
+	return siginfo_put_user(iw->infop, &iw->info, signo);
 }
 
 static int io_waitid_finish(struct io_kiocb *req, int ret)
diff --git a/kernel/exit.c b/kernel/exit.c
index 1c9d1cbadcd0..e3a0b6699a23 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1723,6 +1723,28 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 	return ret;
 }
 
+bool siginfo_put_user(struct siginfo __user *infop, struct waitid_info *wi,
+		      int signo)
+{
+	if (!infop)
+		return true;
+
+	if (!user_write_access_begin(infop, sizeof(*infop)))
+		return false;
+
+	unsafe_put_user(signo, &infop->si_signo, Efault);
+	unsafe_put_user(0, &infop->si_errno, Efault);
+	unsafe_put_user(wi->cause, &infop->si_code, Efault);
+	unsafe_put_user(wi->pid, &infop->si_pid, Efault);
+	unsafe_put_user(wi->uid, &infop->si_uid, Efault);
+	unsafe_put_user(wi->status, &infop->si_status, Efault);
+	user_write_access_end();
+	return true;
+Efault:
+	user_write_access_end();
+	return false;
+}
+
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 		infop, int, options, struct rusage __user *, ru)
 {
@@ -1737,23 +1759,9 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 		if (ru && copy_to_user(ru, &r, sizeof(struct rusage)))
 			return -EFAULT;
 	}
-	if (!infop)
-		return err;
-
-	if (!user_write_access_begin(infop, sizeof(*infop)))
+	if (siginfo_put_user(infop, &info, signo))
 		return -EFAULT;
-
-	unsafe_put_user(signo, &infop->si_signo, Efault);
-	unsafe_put_user(0, &infop->si_errno, Efault);
-	unsafe_put_user(info.cause, &infop->si_code, Efault);
-	unsafe_put_user(info.pid, &infop->si_pid, Efault);
-	unsafe_put_user(info.uid, &infop->si_uid, Efault);
-	unsafe_put_user(info.status, &infop->si_status, Efault);
-	user_write_access_end();
 	return err;
-Efault:
-	user_write_access_end();
-	return -EFAULT;
 }
 
 long kernel_wait4(pid_t upid, int __user *stat_addr, int options,
diff --git a/kernel/exit.h b/kernel/exit.h
index f10207ba1341..b7e0e32133fa 100644
--- a/kernel/exit.h
+++ b/kernel/exit.h
@@ -27,4 +27,6 @@ long __do_wait(struct wait_opts *wo);
 int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
 			  struct waitid_info *infop, int options,
 			  struct rusage *ru, unsigned int *f_flags);
+bool siginfo_put_user(struct siginfo __user *infop, struct waitid_info *wi,
+		      int signo);
 #endif

-- 
Jens Axboe

