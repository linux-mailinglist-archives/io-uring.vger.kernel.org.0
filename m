Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0681B13491A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 18:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgAHRUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 12:20:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36884 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgAHRUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 12:20:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so1390279plz.4
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 09:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E7HgQr6yDjSPTSt5/Fy9dcD9f8QOeckViLXJCA3E09M=;
        b=fYdJh0bJR1OjJ2r4+ghc7vuVufiy2tSL+cw0zFWmAbo1mSQ9DWYuRvMsQlf0+LPByP
         JIVxyu3Y7Woy1p/9hPQNwXTdKzseP1mLuDlViKnkZjJ83TkSQQiPnOeYRCuapc8Yu0Gx
         uV7RjkS9XuTsWUq/zZXU1WCt6Z5w3KWBhJGpeTid0imAv3N9de7NFrF9jkQEWLGigoId
         YVZJjOQxV3oK9HLHg4e63qRmy9W6cTs2W/R/Hn0prfLUGW2VQPWMNSb0IKj8yL0gUJsT
         45QBtdJaw4ADeva0UuwZExKYmwkySY+5b6Fzzssdo+ywOQ5oSUxVql15psk4aQ2vrhOG
         PEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7HgQr6yDjSPTSt5/Fy9dcD9f8QOeckViLXJCA3E09M=;
        b=SQFkCX0CpBYH93mHP5QzkS24zW8dDvKmsP91C/OSp/5zi8J67mcGlhMTYUpoyshseD
         hOPcinERh479qFJY4+A3QRA3nMCdq+4v4GBHGK4O50LWvSkq3oohUrbwJCG8aRsV3o+i
         wwAi77KgF1U1ikylXOq9E6YBgwscDb/dXaCtagyRx47YjUK6vfLA3tLYgAIHlrUDIPK4
         weT0A+6cMZmc39HMJlqStVr8R7k9mZK0+dPbstFeQH1YBdQPFP3eMorzC83tBrn5wOF7
         LJ21esEBOrYg+KcsUAcettWjyI4Dge3Q0+7bDIDXc7F82UKuOXrJBGYskkXr8QvhRldM
         no6w==
X-Gm-Message-State: APjAAAXPvM9NlDYzu1I1qSKNiM7C8bJkMHRRtgSe0UC5AEyBDJBaOaw6
        uVb6A8K372aWBO3Ys0P3FrWp/cvk0es=
X-Google-Smtp-Source: APXvYqzN6p9RHYkZNCaj8lOpyaQV3nDF/74JrTQTroclBKWvRf/EJhbNkaJfYlEOuHztb1FwXWCKqQ==
X-Received: by 2002:a17:90a:22a5:: with SMTP id s34mr5663568pjc.8.1578504003151;
        Wed, 08 Jan 2020 09:20:03 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 80sm4384838pfw.123.2020.01.08.09.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:20:02 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
From:   Jens Axboe <axboe@kernel.dk>
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring@vger.kernel.org
References: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
 <02106C23-C466-4E63-B881-AF8E6BDF9235@icloud.com>
 <f0c6bab5-3fd3-a3c5-8924-62adb419a865@kernel.dk>
Message-ID: <d1ac6188-2ea4-6dbc-b7d9-02ee356400e7@kernel.dk>
Date:   Wed, 8 Jan 2020 10:20:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f0c6bab5-3fd3-a3c5-8924-62adb419a865@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 9:50 AM, Jens Axboe wrote:
> On 1/8/20 9:46 AM, Mark Papadakis wrote:
>> Thus sounds perfect!
> 
> I'll try and cook this up, if you can test it.

Something like the below.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06fdda43163d..70478888bb16 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -206,6 +206,7 @@ struct io_ring_ctx {
 		bool			account_mem;
 		bool			cq_overflow_flushed;
 		bool			drain_next;
+		bool			eventfd_async;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -960,13 +961,20 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
+static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+{
+	if (!ctx->eventfd_async)
+		return true;
+	return io_wq_current_is_worker() || in_interrupt();
+}
+
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (ctx->cq_ev_fd)
+	if (ctx->cq_ev_fd && io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
@@ -6552,10 +6560,17 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_update(ctx, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 		ret = -EINVAL;
 		if (nr_args != 1)
 			break;
 		ret = io_eventfd_register(ctx, arg);
+		if (ret)
+			break;
+		if (opcode == IORING_REGISTER_EVENTFD_ASYNC)
+			ctx->eventfd_async = true;
+		else
+			ctx->eventfd_async = false;
 		break;
 	case IORING_UNREGISTER_EVENTFD:
 		ret = -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index be64c9757ff1..02e0b2d59b63 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -192,6 +192,7 @@ struct io_uring_params {
 #define IORING_REGISTER_EVENTFD		4
 #define IORING_UNREGISTER_EVENTFD	5
 #define IORING_REGISTER_FILES_UPDATE	6
+#define IORING_REGISTER_EVENTFD_ASYNC	7
 
 struct io_uring_files_update {
 	__u32 offset;

-- 
Jens Axboe

