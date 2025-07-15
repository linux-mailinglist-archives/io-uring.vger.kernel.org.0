Return-Path: <io-uring+bounces-8687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D011B06696
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 21:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D58364A80D5
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 19:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907422C08AB;
	Tue, 15 Jul 2025 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ohqHyXu6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14CA2BFC7F
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752606745; cv=none; b=BcCUF38hFhTIfys2RkwN76cH/APixDunQtVG2tXTPygM+oj097rnwxfOpYx1dgXcYJ4ufP3q5l1OSKaX1VK+jM4NXBI0gXqrJgS1aI0ECMBCi7YKtW6GJCnHhC7BIvFnZL3m/t21NzOcdzTKMOBJxRg7YomHRUZ2D/EDnRs9hX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752606745; c=relaxed/simple;
	bh=zC3215NA9eIHNo4ymcl6NpI8lk93Wge2fzJ7R0ov+ZE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TFViS83dhwPcsjq5nMW8oZNSeqPWrRgnOOXiW095C9VJIJTVI+kGN1tK/VVRKfLoRJKzrYe6bdIIr+DdrpY0UOuzJxneSXVaJr9K2GCjM2EHSwj4vzzj0ht2tiLip6b7h0pR3QMZ5dCQ1kPSGahim9MFVeiMa7ez7dwIWaLYhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ohqHyXu6; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-875acfc133dso239672239f.1
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 12:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752606741; x=1753211541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iYbaEIWNySzaGQU5FMj9Tv/HAGKBlXGOUe8MvvdWnQs=;
        b=ohqHyXu6TakayKNebul0UaERyzQ1LWM1vuFeTmb5BO5fUEwwsvLnhK5JJJLO0iu+I0
         25OjkrtIUEc6rTNbe4QyjOkWbvHpAil8OZzhvCHcBIKRjSke1sncoYDRnaU7xZt0Lkkt
         ArtSJ4qvg9Uw6x8e32e2ETbHW33ZJNHafsU4ZhADBwCWGbrsZIlJboiFsT6WkwOr/ShL
         760NHXMbPgM0wb0qhR7wpcucfoQ/VMkx2uWu/Qnxjvy6Sm51faTVlu83LBRPLJE29sF9
         SUu1XgqoX0+ycTUe/quPj3S6J7buC1f78F/EF2ZkJ/QW8TQguJNvZGXh0xO14tKRKRsK
         jzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752606741; x=1753211541;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iYbaEIWNySzaGQU5FMj9Tv/HAGKBlXGOUe8MvvdWnQs=;
        b=hytOF7cYXau08v1FM5Y4rO1rQcOcCsf9G0/mNe3us9NwnliziNIcmytFEf9YR5X7xG
         LIj8WDKHfb66SlA7ZRNn1Of4SD2R18h4BAPmhWgWTa1wHQoGHmAg39KnDyOwNd2UN2Kq
         TqYyCzOObG+RmqMCudON/bOuwMOtnjaLEIznfTcU91HuuNw469pb53iQhRpEhLQ8vFM4
         NO9Vd2yT8iPlswzk9QcHTT47TaUXfqfmjJSuXq4qE+1pMu/a/3kg22YngBo09AIJLRQs
         7jcpzIlcJM+cQRzfjznJTK08AT/gPQ8pkHdzzdaS/NS06PNWCpKNGygcQ7Tw4rUp/S4M
         TiGw==
X-Forwarded-Encrypted: i=1; AJvYcCVP/Lm8eejGrwCdwHI0PlCSXslnd7XktntGZi59du3MsZ3EVorg2fLG+0UCvc8HftN8efnQWDnrzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDauQ2B8o1hjseV6kJJV6KfgT9n6wgSnl4nI+V//XHaxQm58+B
	ggSxDHWGn9uZ2UfXyPUYcbFsFryLkpMkLLMxfnlfbaWSyBG+Ps7xcqJ/z+vVu/hCmYc7atOq5LK
	pADf+
X-Gm-Gg: ASbGncvHWlIjv2R1SsIWRJemJ50SH4Qff8qqL6SGLG0n97NSKfSk/hAx6ZXf6gIy4io
	yU/RYxJtFyHqcml7mdcxcNyPgm8wxiivVQda1M7Dl9+9O90T3a4JTgy75g88S1h2Nt7cndPYnX6
	BUOAxdvra10Jk7V1gKoctkYGZdfXo48ExGOMnxivPZ2jW7SoydvDeGDPe+ZQ7Kd4353nA4/rAzG
	wn2uWwglWQ8yRYK73O30ZVNDCWw9II8WYBRXE5K2fes2A5qGfn5Tu+FzuI2f1VrB9y3irxRK7L5
	gp4dCDf91Srus4/OUc/d+dk7HMuL5axquzajWYtDL1zqs7rTJcnFhh9mzRqfqjJNZyPqPAvKwkL
	yd45n6Ko8/Hp1aItGdg==
X-Google-Smtp-Source: AGHT+IFZ9nPfPc33NCAYcPlnEqGf4fL0c8D0qxYoOEAn7GCznQEk92JYnRmIUVaKYkXgaePJ8+JZrg==
X-Received: by 2002:a05:6e02:4706:b0:3df:385d:50a8 with SMTP id e9e14a558f8ab-3e2823641fcmr2905105ab.6.1752606740842;
        Tue, 15 Jul 2025 12:12:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556535d36sm2685082173.12.2025.07.15.12.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 12:12:19 -0700 (PDT)
Message-ID: <cb896d1f-6260-4ba6-b6f6-6b4693f5e6b3@kernel.dk>
Date: Tue, 15 Jul 2025 13:12:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
 <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
 <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
 <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
 <bf0de1c6-64e6-4a4a-b741-3fab0576339f@gmail.com>
 <8d9a1230-0db4-4f7a-bca8-565465d3c186@kernel.dk>
Content-Language: en-US
In-Reply-To: <8d9a1230-0db4-4f7a-bca8-565465d3c186@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 12:13 PM, Jens Axboe wrote:
> On 7/15/25 3:06 AM, Pavel Begunkov wrote:
>> On 7/14/25 21:45, Jens Axboe wrote:
>>> On 7/14/25 11:51 AM, Jens Axboe wrote:
>>>> On 7/14/25 9:30 AM, Pavel Begunkov wrote:
>>>>> On 7/14/25 15:56, Jens Axboe wrote:
>>>>>> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>>>>>>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>>>> is a little dirty hack that
>>>>>>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>>>>>>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>>>>>>> 2) deviates the connection request behaviour from connect(2), and
>>>>>>> 3) racy and solved at a wrong level.
>>>>>>>
>>>>>>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>>>>>>> patch. At least solve 1) by moving the hack out of generic poll handling
>>>>>>> into io_connect().
>>>>>>>
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> ---
>>>>>>>    io_uring/net.c  | 4 +++-
>>>>>>>    io_uring/poll.c | 2 --
>>>>>>>    2 files changed, 3 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>>>> index 43a43522f406..e2213e4d9420 100644
>>>>>>> --- a/io_uring/net.c
>>>>>>> +++ b/io_uring/net.c
>>>>>>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>      int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>    {
>>>>>>> +    struct poll_table_struct pt = { ._key = EPOLLERR };
>>>>>>>        struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>>>>>>        struct io_async_msghdr *io = req->async_data;
>>>>>>>        unsigned file_flags;
>>>>>>>        int ret;
>>>>>>>        bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>>>>>    -    if (unlikely(req->flags & REQ_F_FAIL)) {
>>>>>>> +    ret = vfs_poll(req->file, &pt) & req->apoll_events;
>>>>>>> +    if (ret & EPOLLERR) {
>>>>>>>            ret = -ECONNRESET;
>>>>>>>            goto out;
>>>>>>
>>>>>> Is this req->apoll_events masking necessary or useful?
>>>>>
>>>>> good point, shouldn't be here
>>>>
>>>> Do you want to send a v2?
>>>
>>> Actually I think it can be improved/fixed further. If POLLIN is set, we
>>
>> How is it related to POLLIN?
> 
> Gah POLLOUT of course.
> 
>>> should let it go through. And there should not be a need to call
>>> vfs_poll() unless ->in_progress is already set. Something ala:
>>
>> In any case, v1 doesn't seem to work, so needs to be done differently.
> 
> RIght, that's what I aluded to in the "improved/fixed" further. FWIW, I
> did dig out the old test case I wrote for this and added it to liburing
> as well. So should have somewhat better coverage now.

How about:

if (connect->in_progress) {
	struct poll_table_struct pt = { ._key = EPOLLERR };

	if (vfs_poll(req->file, &pt) & EPOLLERR)
		goto get_sock_err;
}
 
with get_sock_err being where we do sock_error()?

-- 
Jens Axboe

