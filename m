Return-Path: <io-uring+bounces-2983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D42A96649D
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 16:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ECC71F253A0
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 14:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EE11B1D63;
	Fri, 30 Aug 2024 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rle6jijk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701DA1B2EDF;
	Fri, 30 Aug 2024 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725029677; cv=none; b=meafcgt/Lxe3xgLqQNG+7oSuuV33DPCpBGOlP28Y7SdKGzgNLN/DBnZPlAFHN4JH4cPEDpsqLJNCDO5n7Nft6TeWw/Hgdub06K5Tb9tZirVmrRkgvFxnHrdXpbGaYZJOVu7K1wW8PqsRnlHNDnAaRWWFmhbT7aofruGLmKBOIvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725029677; c=relaxed/simple;
	bh=+s3M/fau8hC378SqLcDfYNV2Lw9rTNn14hQ1aqWbsSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZQNp9GkufaNYHXgXdfCxGH+brmFkOgXQdExcmvwV0k76oXJrAf3vI/WrsrjRUKe2y+B9uuxkcEjQFC/HhLs7hzbgIdOWbRy6KJs/KCOKNnGLiv7maWTLI/gSKfs9stWHO+BQ/CFJu7JP4MT+kKiRbkWLrXCWBQIv6YtxcbOhFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rle6jijk; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a86e9db75b9so206238766b.1;
        Fri, 30 Aug 2024 07:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725029674; x=1725634474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nkikf2MSZB94E/QoW1aqZZt4hVlAfmk4TRFQ1l1dTFw=;
        b=Rle6jijkeISHlSttKsqxzq5+t7ph/1Bl5w9+n/EYsbAiaR9eZUJEE+4DGwNVIc2QQv
         meEjCd8p2EMJvNjxsoIws64Ul9agNRLKcDXJ0A0evOQMgXo6TcZB9yuyFUdZFsNRvj+e
         RDIIXGGQlQK17nksP+6x6HjSpSzx87oMyVHK1mgciAfOgWSyZwfAQ67yWFewUavFg02P
         KI4XKDBYTyBP4sB12bHcLbxPuIvx/+ZgN1DnHgiDcZ4jfG6Nt/Z0/XUW4cIVBN5Fsl2D
         p724aaRb8BffVyrffxcpx43E3C5mPzQ33WNVgkKaHOLXbB13n/gya884ggQtM1RgffFP
         lA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725029674; x=1725634474;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nkikf2MSZB94E/QoW1aqZZt4hVlAfmk4TRFQ1l1dTFw=;
        b=BvN+D1w/sBam3EukjrYNcBnrSk21Q8jYqRDxyimYj5zvlWDgnMdB+oqiMC0Ivcr6JV
         fZVRk4+Mog+hMvfJVLCWxFhP6t9HR2BJSRR2j1uQOnHC2KePeGFKo4DJVRPyRIkxvayZ
         1ru33Od+EPxp4fcj3LvLM/c1VvW4OamXxF/J3L3QARKHFiZgNTzDIo+n5wPqs2tTDURp
         kU3YbwLVIOSG4wNlJt1YWDQWaLFk5ouJGSgfTcTQZZgjF5yTmgKobOf0Gf57sdpj+r8L
         +nGfJgb3q/uFqP/sFEVhuNWpXJtHk6OIMlCj89orh1b6+fItpL4g3NxpYhLQ1chXNq0t
         DXTg==
X-Forwarded-Encrypted: i=1; AJvYcCUcpGVFyOMZ0OB5aN6cnLoa50BKGlu9Qoh9rf0bJaRmtAvy+8rpIII/SWpZOkDI+S4ZqSddXNLBlgpI7OpV3g==@vger.kernel.org, AJvYcCXkPfO85V8rcBVOS4Gl2jR4A6qf8v56RUKp7OiK/anId3Lc7ukRZlWHbtvuRGpy+TOZJiXgD1wZBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/XLI/50Jf1AWQpgaVHBNJk/QKozCo8XG2UW2LOcDxcDlcJl1O
	CCk9b2W+ThZrdCYu2Num1Ue24njDNXEKwR3K/0j+6AQO0HphhydF
X-Google-Smtp-Source: AGHT+IEp55CmJ5qDSsHijGyFHv1SkNqxpbFU8yYaOddxUUB4XK6726c2qVj2G+/lomVpfXN6yxbceg==
X-Received: by 2002:a17:907:2d8c:b0:a77:f2c5:84a9 with SMTP id a640c23a62f3a-a897f84bc03mr583960366b.18.1725029673301;
        Fri, 30 Aug 2024 07:54:33 -0700 (PDT)
Received: from [192.168.42.214] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feacccsm228239866b.19.2024.08.30.07.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 07:54:33 -0700 (PDT)
Message-ID: <d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com>
Date: Fri, 30 Aug 2024 15:55:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>, Joanne Koong <joannelkoong@gmail.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
 <7d42edd3-3e3b-452b-b3bf-fb8179858e48@fastmail.fm>
 <093a3498-5558-4c65-84b0-2a046c1db72e@kernel.dk>
 <f5d10363-9ba0-4a1a-8aed-cad7adf59cd4@ddn.com>
 <3ca0e7d1-bb86-4963-aab7-6fc24950fe84@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3ca0e7d1-bb86-4963-aab7-6fc24950fe84@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/24 14:33, Jens Axboe wrote:
> On 8/30/24 7:28 AM, Bernd Schubert wrote:
>> On 8/30/24 15:12, Jens Axboe wrote:
>>> On 8/29/24 4:32 PM, Bernd Schubert wrote:
>>>> We probably need to call iov_iter_get_pages2() immediately
>>>> on submitting the buffer from fuse server and not only when needed.
>>>> I had planned to do that as optimization later on, I think
>>>> it is also needed to avoid io_uring_cmd_complete_in_task().
>>>
>>> I think you do, but it's not really what's wrong here - fallback work is
>>> being invoked as the ring is being torn down, either directly or because
>>> the task is exiting. Your task_work should check if this is the case,
>>> and just do -ECANCELED for this case rather than attempt to execute the
>>> work. Most task_work doesn't do much outside of post a completion, but
>>> yours seems complex in that attempts to map pages as well, for example.
>>> In any case, regardless of whether you move the gup to the actual issue
>>> side of things (which I think you should), then you'd want something
>>> ala:
>>>
>>> if (req->task != current)
>>> 	don't issue, -ECANCELED
>>>
>>> in your task_work.nvme_uring_task_cb
>>
>> Thanks a lot for your help Jens! I'm a bit confused, doesn't this belong
>> into __io_uring_cmd_do_in_task then? Because my task_work_cb function
>> (passed to io_uring_cmd_complete_in_task) doesn't even have the request.
> 
> Yeah it probably does, the uring_cmd case is a bit special is that it's
> a set of helpers around task_work that can be consumed by eg fuse and
> ublk. The existing users don't really do anything complicated on that
> side, hence there's no real need to check. But since the ring/task is
> going away, we should be able to generically do it in the helpers like
> you did below.

That won't work, we should give commands an opportunity to clean up
after themselves. I'm pretty sure it will break existing users.
For now we can pass a flag to the callback, fuse would need to
check it and fail. Compile tested only

commit a5b382f150b44476ccfa84cefdb22ce2ceeb12f1
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Aug 30 15:43:32 2024 +0100

     io_uring/cmd: let cmds tw know about dying task
     
     When the taks that submitted a request is dying, a task work for that
     request might get run by a kernel thread or even worse by a half
     dismantled task. We can't just cancel the task work without running the
     callback as the cmd might need to do some clean up, so pass a flag
     instead. If set, it's not safe to access any task resources and the
     callback is expected to cancel the cmd ASAP.
     
     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ace7ac056d51..a89abec98832 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
  	/* set when uring wants to cancel a previously issued command */
  	IO_URING_F_CANCEL		= (1 << 11),
  	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
  };
  
  struct io_zcrx_ifq;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8391c7c7c1ec..55bdcb4b63b3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
  static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
  {
  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task->flags & PF_EXITING)
+		flags |= IO_URING_F_TASK_DEAD;
  
  	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
  }
  
  void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

-- 
Pavel Begunkov

