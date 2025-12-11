Return-Path: <io-uring+bounces-11011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39132CB587D
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 11:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E153E3013968
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 10:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DBD2E7198;
	Thu, 11 Dec 2025 10:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JWYT7uR4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FF3303CAA
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765449234; cv=none; b=f75NL0dFx8vzw/TofV5+uWDlJFhkpF3z1ZNQnFnBaN9kck8oIdjNfiUkcvG+TTxTNklq3IFY+rS2wHN9v43zyOps/D1hpvik+SyGdcH6D51hO+0jACs8FAh92FEw9BUf3idUpxrlvKxvywjdihWBIig5Rrv+09dKYmUyfDab2yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765449234; c=relaxed/simple;
	bh=QhUjSFQfZn3R7at7FYJNEbk+Pqft7OC3kiYFVws2FLg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AAlHpdjFDoy/nnIpxRE1NGw5x20N3264fZidylut7MHQJEwEgXluM2RbP3pqXrwGnLGNKGfY1mymWKzlvjah0j6BVpGKewYus2N2iavSEBn7nR/kR32cFOGfYF2KjDUAruPCSA0Mg9yuHyrnCqtXiS8d0ZWMiQekbCC+cyOAp/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JWYT7uR4; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-29845b06dd2so10261555ad.2
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 02:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765449227; x=1766054027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IMzRLmiSJlclDk3J5XUyEVJIVr3CldXDSEfIMKMuBv4=;
        b=JWYT7uR4kasAAfm4o5nPRasLBic78VoyJihE4Souz/sTrJAVoRHaITRHZlO33CM+4f
         ZHuR3oYM1d2Y8oF79UROEv2qUdtZ0Ou0jSKH3LlQZNzhjo0PSJWPSpOux4lmplW1S1ry
         ZFeKiqU+1EbULoSK0Bwxt5ZX5RcLwOeLgQ8dBNmAy5aIljkrXviPajEYbImnMQApw69z
         Fcr/1aPqsswEkHMYnZhUAcVdMF7GYyIH3Tog4gg+eiBuQ53MlUvlaSUi7+gOAQcsE0ve
         9YhWdHplqabnVGr518wW7Ep1ZMzXQaBK8koJFiVnfudHuOQVVQUagpFYAx7rbcOJBOwr
         6Ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765449227; x=1766054027;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMzRLmiSJlclDk3J5XUyEVJIVr3CldXDSEfIMKMuBv4=;
        b=RUEM/IGuDLPHoWtmArcuudAoq450Rs2fGxPRqegBqEOO7OwboFbuUFh6z5QSzfRDft
         QZmXfbJKgCFTxDo0iErRf9qW6PNwSvbg59u0RDK+rU5m+hik5uaDMahe176R9XGluLbj
         Gz2b4Y6SCTFEIDYBCeCd3VChI/JG7d7h++FWyFXpJNolt85U2K3usDUsk0iM/0649dMy
         6YidpE3375AgDRwqsYwpn6ZKtP0BnuOOUKyYzowNWgaOHkVQmDUW9q79P5k6MArxEt1x
         lz+41vQn3iRqOPwpVv3iU6jNglZtDDysKtl90F41rldEYipPtcvsOxgi9qeQrDUnVMbe
         uMPg==
X-Forwarded-Encrypted: i=1; AJvYcCUe1TQoMd3QnKOyLY79N46m7o9atW8E+JXTUREeETWB3Zlg1CkEfKbFQ+OOr9cQR3iKFXmOK6rAtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlpJLPiMJPNfJqaKtOmO5G7gBHl3A/+TrXfh2BKI0vWoUJUxB5
	IPLLJpF0WtiiasaQAixEmai1jq5nnZ/F3J7XKv3I3AZ3yPiqdg+rZ+ck7qJ70N7vJZw=
X-Gm-Gg: AY/fxX4M1+Ky2lls2mEGbnAIHKvBzUmfM/gEdjoJm4vqzDkxM6WDOQvW4zH+P5cOaMN
	jb/Sjag05TT9eAZf0U7TEfs1frqkPr2GywwFbQOUShtOsmPsQ+NAl6B4kozlLiecRABmNI3Fzfq
	BXzQFYplv+RbE0g3qkBUtEU7foa9U4l6tdAxIha6Gh4VEeNbEfgV+itkydEUV6/vFzHeSk1ya9T
	LW1jfgTbIlRLYn3EkAV96p8uHId4jXrtIQZoGy7jxrBjmT6RqZF2g4ePCnDYIXBUtdxZrv2r4Gx
	7ad15M0CWC66JAabIUoq2NXUqUu9m4mX+I+pvZYeOKKILCgb3nUQvnkDtF1FrSjqec6MCjTKvsq
	CSb63BtYcWoOIWA+AeniDFwo8ulRuqeURbJtk2Y4a+On+CmfBLZNncRp/+wfKO6eF9LPrWhwYtl
	6l9rbeVXNVVzsFVLe3LlT5cUzjR4944DN1kaIzzcdQQSqahd59BA==
X-Google-Smtp-Source: AGHT+IGZPIxzu4YlVn+rKlKzUN4TBNm42bnEXraSjYEQVwxWvUypf5BpMLtweH6DNmkIVNvCCewLTA==
X-Received: by 2002:a05:7022:220c:b0:119:e569:f279 with SMTP id a92af1059eb24-11f296d7f9cmr5184988c88.34.1765449226897;
        Thu, 11 Dec 2025 02:33:46 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e1bb45csm6738176c88.1.2025.12.11.02.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 02:33:46 -0800 (PST)
Message-ID: <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
Date: Thu, 11 Dec 2025 03:33:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
From: Jens Axboe <axboe@kernel.dk>
To: Fengnan <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
Content-Language: en-US
In-Reply-To: <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 3:22 AM, Jens Axboe wrote:
> On 12/11/25 12:38 AM, Fengnan wrote:
>>
>>
>> ? 2025/12/11 12:10, Jens Axboe ??:
>>> On 12/10/25 7:15 PM, Jens Axboe wrote:
>>>> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>>>>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>>>>> is considered that the current req is the actual completed request.
>>>>> This may be reasonable for multi-queue ctx, but is problematic for
>>>>> single-queue ctx because the current request may not be done when the
>>>>> poll gets to the result. In this case, the completed io needs to wait
>>>>> for the first io on the chain to complete before notifying the user,
>>>>> which may cause io accumulation in the list.
>>>>> Our modification plan is as follows: change io_wq_work_list to normal
>>>>> list so that the iopoll_list list in it can be removed and put into the
>>>>> comp_reqs list when the request is completed. This way each io is
>>>>> handled independently and all gets processed in time.
>>>>>
>>>>> After modification,  test with:
>>>>>
>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>>>>> /dev/nvme6n1
>>>>>
>>>>> base IOPS is 725K,  patch IOPS is 782K.
>>>>>
>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>>>>> /dev/nvme6n1
>>>>>
>>>>> Base IOPS is 880k, patch IOPS is 895K.
>>>> A few notes on this:
>>>>
>>>> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>>>>     necessarily safe. Yes generally this is invoked from the
>>>>     owning/polling task, but that's not guaranteed.
>>>>
>>>> 2) The patch doesn't apply to the current tree, must be an older
>>>>     version?
>>>>
>>>> 3) When hand-applied, it still throws a compile warning about an unused
>>>>     variable. Please don't send untested stuff...
>>>>
>>>> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>>>>     singly to a doubly linked list, you're growing the io_kiocb size. You
>>>>     should be able to use a union with struct io_task_work for example.
>>>>     That's already 16b in size - win/win as you don't need to slow down
>>>>     the cache management as that can keep using the linkage it currently
>>>>     is using, and you're not bloating the io_kiocb.
>>>>
>>>> 5) The already mentioned point about the cache free list now being
>>>>     doubly linked. This is generally a _bad_ idea as removing and adding
>>>>     entries now need to touch other entries too. That's not very cache
>>>>     friendly.
>>>>
>>>> #1 is kind of the big one, as it means you'll need to re-think how you
>>>> do this. I do agree that the current approach isn't necessarily ideal as
>>>> we don't process completions as quickly as we could, so I think there's
>>>> merrit in continuing this work.
>>> Proof of concept below, entirely untested, at a conference. Basically
>>> does what I describe above, and retains the list manipulation logic
>>> on the iopoll side, rather than on the completion side. Can you take
>>> a look at this? And if it runs, can you do some numbers on that too?
>>
>> This patch works, and in my test case, the performance is identical to
>> my patch.
> 
> Good!
> 
>> But there is a small problem, now looking for completed requests,
>> always need to traverse the whole iopoll_list. this can be a bit
>> inefficient in some cases, for example if the previous sent 128K io ,
>> the last io is 4K, the last io will be returned much earlier, this
>> kind of scenario can not be verified in the current test. I'm not sure
>> if it's a meaningful scenario.
> 
> Not sure that's a big problem, you're just spinning to complete anyway.
> You could add your iob->nr_reqs or something, and break after finding
> those know have completed. That won't necessarily change anything, could
> still be the last one that completed. Would probably make more sense to
> pass in 'min_events' or similar and stop after that. But I think mostly
> tweaks that can be made after the fact. If you want to send out a new
> patch based on the one I sent, feel free to.

Eg, something like this on top would do that. Like I mentioned earlier,
you cannot do the list manipulation where you did it, it's not safe. You
have to defer it to reaping time. If we could do it from the callback
where we mark it complete, then that would surely make things more
trivial and avoid iteration when not needed.


diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cae9e857aea4..93709ee6c3ee 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -917,6 +917,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	else if (iob->complete != complete)
 		return false;
 	iob->need_ts |= blk_mq_need_time_stamp(req);
+	iob->nr_reqs++;
 	rq_list_add_tail(&iob->req_list, req);
 	return true;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 72e34acd439c..9335b552e040 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1821,6 +1821,7 @@ void bdev_fput(struct file *bdev_file);
 struct io_comp_batch {
 	struct rq_list req_list;
 	bool need_ts;
+	int nr_reqs;
 	void (*complete)(struct io_comp_batch *);
 };
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 307f1f39d9f3..37b5b2328f24 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1358,6 +1358,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		iob.complete(&iob);
 
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
+		if (nr_events == iob.nr_reqs)
+			break;
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			continue;

-- 
Jens Axboe

