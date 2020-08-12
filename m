Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B208243173
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 01:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLXcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 19:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHLXcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 19:32:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9076C061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 16:32:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so1831415pgl.11
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 16:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X1f7IK2Pz3P56Q5nbShvsUCj8kJPMfZNf8B/BLSuT4g=;
        b=GgGoBLC1gWzE5BHqqzp25AeG+21OElPIgjm0fmARtixa/HmAWHgngG+SLmTpxTJKIk
         DO2CHi6uGgJXDKgWbVuWGyF0e9yFVPPySBmNXQGL19CiPDVownknAZd3AEFKyfO40zYZ
         gVPZ6KoosaZMd4Q9D/hD36MTLh5HYq9XsA2ILGXkCl+U1vv2Lr0L9RNw8ouYYyXw7lHh
         E8fu4q0uSKMKQ5lQJXYqVe8Lmb5OhC1K47cCTnoFLVi7euS9ieNRG2Uk9XLz4WJFwVOp
         JZt9FW9Vq90yNxEG2GWVRiKdy+KJAb6+wV138572S+bl4JQDTPlDDTuUPX+FjCiKZWbU
         NfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1f7IK2Pz3P56Q5nbShvsUCj8kJPMfZNf8B/BLSuT4g=;
        b=tEJ15Ts4d29d1o97YXlE9ncHnGNmtjd4krdde94YzDw46qGDvY+Gs31R/yBYMy01fC
         anRDl6ILPZ+yyj027DR8VFLnQmV0khGDBFQw0GI79OvUafOaIzF/w32W/S6bJMaQm23W
         CCuXtiFkcInv0r1BSP1zc1eSsEs8+11+1VWkUm072q5FDy06gpoLmwhzDBFiu8kOAUfP
         hOOxzQkKFVY7B8+b62bJJ3zMFsw5epQNRZDELOQdm2ASEylNkW8VIUxhOwV+ZGwKggXo
         agRc11nraAe7LB5weycRMXBG+pGwkEuqa2gh/0WgQA3gjUOhvApfSHfZIvTZZhtSgKAX
         6RVg==
X-Gm-Message-State: AOAM533hrq/gcO6wejEEDVMOEJK62EoHKIpVN3DFIeb0fL7kQf3Ko9yw
        z9b2sIfq9N4+Lf4h1jRLW7jSoxQc37w=
X-Google-Smtp-Source: ABdhPJzqG0Vsc40vkNHHITk65j3mDIIT3cArcmRbF4s0zqSQXw/xAwFowtQICGoPKYwfIWgiljC+DQ==
X-Received: by 2002:a63:f444:: with SMTP id p4mr1279816pgk.451.1597275124192;
        Wed, 12 Aug 2020 16:32:04 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j5sm3544275pfg.80.2020.08.12.16.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 16:32:03 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
Date:   Wed, 12 Aug 2020 17:32:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/20 12:28 PM, Pavel Begunkov wrote:
> On 12/08/2020 21:22, Pavel Begunkov wrote:
>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>> Hi,
>>>>>
>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>> works
>>>>>
>>>>> I've attached a file to reproduce it
>>>>> or here
>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>
>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>> state, which is why you can't kill it.
>>>
>>> It looks like one of the hangs I've been talking about a few days ago,
>>> an accept is inflight but can't be found by cancel_files() because it's
>>> in a link.
>>
>> BTW, I described it a month ago, there were more details.
> 
> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com

Yeah I think you're right. How about something like the below? That'll
potentially cancel more than just the one we're looking for, but seems
kind of silly to only cancel from the file table holding request and to
the end.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a2afd8c33c9..0630a9622baa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4937,6 +5003,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
 		req->flags |= REQ_F_COMP_LOCKED;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 
@@ -7935,6 +8002,47 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 	return work->files == files;
 }
 
+static bool __io_poll_remove_link(struct io_kiocb *preq, struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	if (!(preq->flags & REQ_F_LINK_HEAD))
+		return false;
+
+	list_for_each_entry(link, &preq->link_list, link_list) {
+		if (link != req)
+			break;
+		io_poll_remove_one(preq);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * We're looking to cancel 'req' because it's holding on to our files, but
+ * 'req' could be a link to another request. See if it is, and cancel that
+ * parent request if so.
+ */
+static void io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *preq;
+	int i;
+
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
+			if (__io_poll_remove_link(preq, req))
+				break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
@@ -7989,6 +8097,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			}
 		} else {
 			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			/* could be a link, check and remove if it is */
+			io_poll_remove_link(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 

-- 
Jens Axboe

