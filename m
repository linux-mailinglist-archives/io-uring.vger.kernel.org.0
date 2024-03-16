Return-Path: <io-uring+bounces-1008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DA287D8B9
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 05:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F087E1C20E7B
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 04:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1CD634;
	Sat, 16 Mar 2024 04:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eyt2XSMj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047295221;
	Sat, 16 Mar 2024 04:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710562503; cv=none; b=l6aYKg2GCn18hpQ63KxZSVj145RxotL/tIlTzlv++PVgV7f6ScaOWweiLsALPS301Ossh3gHkYjlxDnA6uffq5Oikbv+s79joMdeKMzo/AQt+oSnotPyC/frxb+tg3shk6pjBlsRvRx+jdwMAuK4nbFE71KC3U1DL0XTlgk5NHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710562503; c=relaxed/simple;
	bh=vni/45wfU6SWD5yI6V7TYwn8MgHpZhrcJGaFrQGXj4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EsTlhzcNZW5dDZLCnU/X5WjggcTdSK4V2T4RTCEjjseTI1Dh0ubX+z1Fas+pShVQ0vYFddAAZ00gnOOQh9jT1obCExxYEdMrHRfYQVdb8db5gmNn2xWoG5RR566I44jIZNuKKIUmXbUJbL8j5LGKJMQNiCL+u9YGHZCBTN8LyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eyt2XSMj; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41408974cbdso541785e9.1;
        Fri, 15 Mar 2024 21:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710562500; x=1711167300; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JTdRU9ev/ZsK6KTEwlFgnrToIZVqFu/eVl1CDy+4F6Y=;
        b=Eyt2XSMj3/CmS6XZCAwBzAzFUw5nskg+ZUgv5mfAa4w0/L4UOFkAGG846f91Jkam7S
         eG9WSo3wDfUCeE/APKd7+O4HU2kbcQfUdpy9M8SDBJUIS1RXNm16paBMnL08FU5DeC9i
         MmX7BpRIn3Awr2oVEx26Eo407VodjD2/8nQucJzYYeDM83oFKu52ZrOctK/7tUKu6SDo
         GOQ94G8lcWqSov+8IWT9QaKJk9uQ9JmEbRnkzAYwsa5AtyxxApL/hNWCyBfsqdwczmUz
         9XTvmwm9J34flybC+gjU7TCVoebjB6J3Qfk7wX88TuBu0la31Uo5mvimiV72uVGJqF26
         Ar8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710562500; x=1711167300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTdRU9ev/ZsK6KTEwlFgnrToIZVqFu/eVl1CDy+4F6Y=;
        b=VHPQpGrH8LXBRRGpgq31ZvYr43m524GM1GJs4/MANIE4moWzXeAi8JBYQUSwhFRX9W
         TmNd1/hhAcbU9Ypg4k4uoy/ud4/FvuFzJMfTHY4kX+Bp2A5DLC7a206l30z50LAbjSi6
         uZV1yhM0SlobRm6LXaKm+dMRGYPD2I0unvDcmVC0D6REmgvd+mXQIQqvy8ET8qZLK5px
         EzKlUZHdMUdhthsk8X1hDZvRfr3qbS46QWDZ9kTOGwNQLRVkXgKtc78IBuY7shSQ7qGg
         XETYclXPYhPjGJZ4bDW28StHRhW2SyW4o1hHgGvYWt15tJazg8RAkazLgIK9HpxjQ1hW
         JFww==
X-Forwarded-Encrypted: i=1; AJvYcCVY/VbjACoxx4RwtQKs3I/Gh83IHZFoBFOuUA7q+IHbOfE/jNLD1Q/JVC+rZta70qEyCDhsoh8SSUBADMOy+f25gbYpI5Q4v3u8ArIOKw7XiozDQJ4BK71wZVIVpQAnv4MMKFVJFg==
X-Gm-Message-State: AOJu0YzlU+W8SXy7BnzJDCJDodiaISEu++pqM+XAe1rWev4DnZvqb80H
	dqP40VoaWBasziGrxkjbtxnj4988VSSaXRPi5FWSJQnFEve9KWYg
X-Google-Smtp-Source: AGHT+IHY2CosxFLCtI6Les4065tITED0HijJd4h6mbSdCOxwc7tmmlgtrfWrpJBBWqY7OVLsQihMgg==
X-Received: by 2002:a5d:53c1:0:b0:33e:d7c1:a132 with SMTP id a1-20020a5d53c1000000b0033ed7c1a132mr922042wrw.29.1710562500017;
        Fri, 15 Mar 2024 21:15:00 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id s15-20020adfeccf000000b0033e9e26a2d0sm4506685wro.37.2024.03.15.21.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 21:14:59 -0700 (PDT)
Message-ID: <f538b6a2-3898-4028-a63c-7641f02f5bdf@gmail.com>
Date: Sat, 16 Mar 2024 04:13:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
 <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
 <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com> <ZfUX/kSYOW6we1SB@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZfUX/kSYOW6we1SB@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 03:54, Ming Lei wrote:
> On Sat, Mar 16, 2024 at 02:54:19AM +0000, Pavel Begunkov wrote:
>> On 3/16/24 02:24, Ming Lei wrote:
>>> On Sat, Mar 16, 2024 at 10:04 AM Ming Lei <ming.lei@redhat.com> wrote:
>>>>
>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>
>>>>> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
>>>>>> Patch 1 is a fix.
>>>>>>
>>>>>> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
>>>>>> misundertsandings of the flags and of the tw state. It'd be great to have
>>>>>> even without even w/o the rest.
>>>>>>
>>>>>> 8-11 mandate ctx locking for task_work and finally removes the CQE
>>>>>> caches, instead we post directly into the CQ. Note that the cache is
>>>>>> used by multishot auxiliary completions.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>
>>>> Hi Jens and Pavel,
>>>>
>>>> Looks this patch causes hang when running './check ublk/002' in blktests.
>>>
>>> Not take close look, and  I guess it hangs in
>>>
>>> io_uring_cmd_del_cancelable() -> io_ring_submit_lock
>>
>> Thanks, the trace doesn't completely explains it, but my blind spot
>> was io_uring_cmd_done() potentially grabbing the mutex. They're
>> supposed to be irq safe mimicking io_req_task_work_add(), that's how
>> nvme passthrough uses it as well (but at least it doesn't need the
>> cancellation bits).
>>
>> One option is to replace it with a spinlock, the other is to delay
>> the io_uring_cmd_del_cancelable() call to the task_work callback.
>> The latter would be cleaner and more preferable, but I'm lacking
>> context to tell if that would be correct. Ming, what do you think?
> 
> I prefer to the latter approach because the two cancelable helpers are
> run in fast path.
> 
> Looks all new io_uring_cmd_complete() in ublk have this issue, and the
> following patch should avoid them all.

The one I have in mind on top of the current tree would be like below.
Untested, and doesn't allow this cancellation thing for iopoll. I'll
prepare something tomorrow.


diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e45d4cd5ef82..000ba435451c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -14,19 +14,15 @@
  #include "rsrc.h"
  #include "uring_cmd.h"
  
-static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
+static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
  {
  	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
-	struct io_ring_ctx *ctx = req->ctx;
  
  	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
  		return;
  
  	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
-	io_ring_submit_lock(ctx, issue_flags);
  	hlist_del(&req->hash_node);
-	io_ring_submit_unlock(ctx, issue_flags);
  }
  
  /*
@@ -80,6 +76,15 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  	req->big_cqe.extra2 = extra2;
  }
  
+static void io_req_task_cmd_complete(struct io_kiocb *req,
+				     struct io_tw_state *ts)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+
+	io_uring_cmd_del_cancelable(ioucmd);
+	io_req_task_complete(req, ts);
+}
+
  /*
   * Called by consumers of io_uring_cmd, if they originally returned
   * -EIOCBQUEUED upon receiving the command.
@@ -89,8 +94,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
  {
  	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
  
-	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
-
  	if (ret < 0)
  		req_set_fail(req);
  
@@ -105,7 +108,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
  			return;
  		io_req_complete_defer(req);
  	} else {
-		req->io_task_work.func = io_req_task_complete;
+		req->io_task_work.func = io_req_task_cmd_complete;
  		io_req_task_work_add(req);
  	}
  }

-- 
Pavel Begunkov

