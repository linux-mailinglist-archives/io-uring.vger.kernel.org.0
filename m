Return-Path: <io-uring+bounces-8671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87BE1B048CC
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 22:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF63D3B7542
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 20:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A422581;
	Mon, 14 Jul 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0yjuHpzy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428A2309B3
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752525947; cv=none; b=j/4wBfzRHu3fry+Dea8RmSEIESofMRfXiNMW8znCkwCln1TMkjlJoEidb3V1kUfL8xprh4zMOca8K7KTr6ywlngF7NC2sm+Ok7gFgnKXnQIsdXpdeyo1RSnDnnUGbtQMvsUjZgGSpcfhrHocWJFLt9Rj1A77FR2gAO2d+tHC+SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752525947; c=relaxed/simple;
	bh=NvELTu/nRZXYBpI9rSZgc87XrvFqaNwr09GfuMlaMtU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ti5ywMPe0geYeNFBbDDV1fkPTSk7okvYUnraxMJVqlQxo7dWp1vrOfzcE4migUoOz2tbtLq4ctPaozU8ylTlv0RSVUmi/oG/9PLUUcdEjnhd536UVt/m3uT1nE34A6acMRbu9FOH5gtktGwQXOVvFvz48Qjw25KOomq5mnpmrKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0yjuHpzy; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-875acfc133dso198751739f.1
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 13:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752525942; x=1753130742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Uch2lnqFAjrU32TF0hPmT76cxGUVmpEE5x2gshhmgA4=;
        b=0yjuHpzy7wzixW4Dog55x2wH8fN2WthSjIu3AG/8FhpUQzmPvDszWTXmyyjAXqK7jV
         lOycJcPZu4/u+i+KXse66fgievLjVvooipxrj9uj+XDL4SF2P5o9VGuxmsz9kQ46ysOT
         kIuzljnTZmqmiQi8UCTucVHQkBpHDAtcdDXutxqcn3gThvoQSkRZQSzGUGgVw0oHDOqR
         L2IFYhloB5jNENpxu/fa0vFWRdIFmQP20VcmhsAUteHVzStna/bLpDVFrr2BYby3yMHO
         lJmOWf6W9vQqAWSXkfBs7L+jUun1hea9xa2XpmrP2zC4NR8NNnFRTlzxv28prt3/Ied0
         Odmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752525942; x=1753130742;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uch2lnqFAjrU32TF0hPmT76cxGUVmpEE5x2gshhmgA4=;
        b=TNAdhGpUZ7hDLPkPz3E1unHbZqx1WKikNqiCwGG9frWjZZsbFdID7QfUprtDZHIZpm
         FcUbnhBxLi7UbneLOWmnZtIcoItFHZFO2NDmfe4QFfSqxlw+eFU2D9QRTSgspNRuzidS
         XhaVoDvoS2CsIMv69N3sE3nND/N2hoeRRGACuswIMnpvYP4iKLJp3hN+YTQ/zhUemVoc
         blLyG2DaJIOnhzCEDV81mwaMRXswUq5JbDsKl3XmVjn9MEyaIaRjPqEuF8mqRmb8Dw/M
         ku7eLXKhZrt4vO3HN1E8yixhSSHtNYm3AJ1iezHCvSQYviOQxDbuC8zq6cLHIaZBqzCG
         QmYg==
X-Forwarded-Encrypted: i=1; AJvYcCVDHRBEmn/jKMqiB40MY9OQr3d0JDK0YJiEljmtsvgj+38J6ALwsMKXmftYD2FvBDu1j/Ea5Tb8qA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFh8FsS7nhn6x6rYasumyikT+z7pHrb9XlZ1Riydj9W7XTwcdo
	nnEkzarkURx0ji7x/89OshHjYpTHnWKdcds/BbIUDJbXu/VT1MDq8EfuX0XgEFgT9NU=
X-Gm-Gg: ASbGncs8Vpnx4i2ozPBUc4hRzjYzJ6NxPFbDaxGin1fGdLmNHN9BfxdSVdKPLv0tnVn
	NEFgwW7VONqlt7Sh6sfqxS26vLPy+VGPTZ63ZxkT3rT0j9AFiD1bg577PtEeN2PHSzC5YySwhc7
	iz5bHacaZW1uK8sSeSbB6Erv/8Ckr0103n30lSRqTd88LHSaMLrFPSzKsWqvKO9l2/g9VcgcMlY
	DJL0o87G1NUrscNhQpfsWtmxoyxSlzZCOfggJxgz0Y7dZ61R2bB6ob4KZ7eesMgBLdCxfAyQa8Y
	AJKqZnbsh17AtlLAbDyvE9CR1rP509+FQpnXQdOEowks47iuC6thdHIYHzsRfxkHVAKWpyfzDlB
	A9mQ9A5Os2n8K036iLWA=
X-Google-Smtp-Source: AGHT+IHXt+HR9lrrgLoqyOfYanD4D+rn5b3ID62a5NfdWKrEik82hvSrcHus3fXdD7Jc8bwq3WJIUQ==
X-Received: by 2002:a05:6602:1414:b0:864:68b0:60b3 with SMTP id ca18e2360f4ac-87977fbc5famr1733086139f.12.1752525942359;
        Mon, 14 Jul 2025 13:45:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc35d66sm270655539f.35.2025.07.14.13.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 13:45:41 -0700 (PDT)
Message-ID: <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
Date: Mon, 14 Jul 2025 14:45:41 -0600
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
Content-Language: en-US
In-Reply-To: <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 11:51 AM, Jens Axboe wrote:
> On 7/14/25 9:30 AM, Pavel Begunkov wrote:
>> On 7/14/25 15:56, Jens Axboe wrote:
>>> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>>>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>> is a little dirty hack that
>>>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>>>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>>>> 2) deviates the connection request behaviour from connect(2), and
>>>> 3) racy and solved at a wrong level.
>>>>
>>>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>>>> patch. At least solve 1) by moving the hack out of generic poll handling
>>>> into io_connect().
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>   io_uring/net.c  | 4 +++-
>>>>   io_uring/poll.c | 2 --
>>>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index 43a43522f406..e2213e4d9420 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>     int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>>>   {
>>>> +    struct poll_table_struct pt = { ._key = EPOLLERR };
>>>>       struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>>>       struct io_async_msghdr *io = req->async_data;
>>>>       unsigned file_flags;
>>>>       int ret;
>>>>       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>>   -    if (unlikely(req->flags & REQ_F_FAIL)) {
>>>> +    ret = vfs_poll(req->file, &pt) & req->apoll_events;
>>>> +    if (ret & EPOLLERR) {
>>>>           ret = -ECONNRESET;
>>>>           goto out;
>>>
>>> Is this req->apoll_events masking necessary or useful?
>>
>> good point, shouldn't be here
> 
> Do you want to send a v2?

Actually I think it can be improved/fixed further. If POLLIN is set, we
should let it go through. And there should not be a need to call
vfs_poll() unless ->in_progress is already set. Something ala:

	if (connect->in_progress) {
		struct poll_table_struct pt = { ._key = EPOLLERR };
		__poll_t mask;

		mask = vfs_poll(req->file, &pt);
		if ((mask & (EPOLLERR | EPOLLIN)) == EPOLLERR) {
			ret = -ECONNRESET;
			goto out;
		}
 	}

avoiding what I'm also guessing will be a sparse complaint on the 'ret'
vs __poll_t use as well. Not that poll.c is free of those already, but
new ones will surely bother me via email.

-- 
Jens Axboe

