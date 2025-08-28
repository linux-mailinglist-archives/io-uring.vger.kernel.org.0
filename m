Return-Path: <io-uring+bounces-9367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F40B39200
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EDC94644C6
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C367C26B76C;
	Thu, 28 Aug 2025 02:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LjJaZjLA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9131B2701C2
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349897; cv=none; b=bTAyhoAFkTjzmY4ah2TXhyyYE6eCCd7VzQ1cPeixy+0BvatZG/ZlXQbivPvjjLFNG3IlUpPbINNyPjOzRiDAkdFIADJv1U/pXFRE3uiiqGowWcfrbcMMTwdgEORENGudHi4mzQGPN4h9OokQzDoK6Ee9PnnbxQWGuyUm9cx9xwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349897; c=relaxed/simple;
	bh=l+yQZ/t14mjjvLnstumLNRAJKE1jbRUCEyo5VZjfaPQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=I+HmGGDi/ili+7pqc63xuvLlo3dITLkOPPvSp7BIwfLxhmzqxQ4Ugavn0gIVHGhKHeyQVWWvVa+jxD+uLUtUEmfMBYl6lMG+1cSvJMrCYfRhTxRivAZ2UpEDsxncvpN59s/hawBJUNrossIIE+PbwVcnQA9SaCaAn3LESfRXqmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LjJaZjLA; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b49b56a3f27so346176a12.1
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 19:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756349894; x=1756954694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5AfvQAEE/xz7gFVRUFMWAKZH/rtj4r6SWVI3b6A8bEo=;
        b=LjJaZjLAVI5zUq/VZvUi2gwuZpv2Bu4HRR1Tw+sFYv/ATqC9gfDOGMg4fyo7+/Pkd1
         SO09C2Sf9p3Ha0VkxF+8Nq8hEeK6EODcLPH4ILtTaSkqAYrZkTJI7TEcD/bgZAi5KCZH
         xc5mOcu1i9aJwfPKkMhkhX5U6JuiWlUHhdqBDUNx9X8P4HRGEjbpmIcw9CO1bByqppUw
         Y0jRJAZtb5hQLBYSFQ7RjpdJIHyr3xQo+dZQvJqBMTFDMDwo53h503d2qBSRv8X9wgRw
         Ne47x9ro4KYZtnOnkxvjSG4xlY3O7fmsDl5FheoLrl97oyJ17Swog3fAsahaHKTrcCru
         nLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756349894; x=1756954694;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AfvQAEE/xz7gFVRUFMWAKZH/rtj4r6SWVI3b6A8bEo=;
        b=T7yVRMrbg+/zZarv++oppE0/ShxogJloPbjoJTTFchAGFD2LhLogBaKTxGszNPO5o0
         lvU+WnwTZhQFhexvQnJ7YsZyTgawD+k/ACILD0xR/LSJBwDIv63igPaVRK2cqP0wgHTt
         dMeKLri4Yfh6+YD0JRQKrYPf4nXer2ls++BETET+kfo14rQQmXoG41Y6IpicLc7DOKw/
         LuPcg+YYnmIgTYo4BVe0Zr/zfrGwX8UQphv+4iqZk5ck+qh4Yi82gMiMT3fHHjZ8md5a
         XeDBbnJXYDs390p0b1pciLpPXGzj5w2DyxhAFMsxeIfQ9JlyzFW2EU+h2YiG03uk1rNR
         zRVg==
X-Forwarded-Encrypted: i=1; AJvYcCUhpwBS9iINnwFrJXgv9fYo9wGJW3zeFSFGQhNoTDvEljW9Xi4n/OzrAU96tC6Mp4oEhhzCeuNztA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/l+1zi82uejs5+8CorOuItyDLWuC4eIIjKxrXHUQDISEOfdc4
	fD/7AvmJOhSM25njjy06b+KPg1CpkuVduGcyQvKAsVXp7cH5MCcuEzgSgJAtv5laHzM=
X-Gm-Gg: ASbGncuUMFFSGl8ZBVy/6/DYXEk6HwjQG44Z9bZSBJ4elfW/UpbNNo4utwEMTmwOKHQ
	ybERxfGefMYzmeltnppEODq9BNNkvXewcpFhn3tNwUw6x4a9aUN6up5Qzgp96txZW9c68qKRn2t
	XH7XHV4QJJqb7h+ISjmWAmqVxIqUO8zpGxaIOQdCq7vneC226yjKBWvuz8UrCVaxNuD6WsUR01S
	zJHHsCa68EPJx8DVFwbf7ekIoVRu8of2Fr5n3mnpjFl9yCaSodzbL0YKg9MpMUF1oFNwylZMddt
	IC8ATunq4jqKsj6x+0dD1+qHpHCF14bT8eFu5/8q1bXxRZ5x0ukdeY561s8d7ox/w+oUEoMWu42
	A+yp/wGWfa2g2N4YUGUYq
X-Google-Smtp-Source: AGHT+IFQiRRG5GRIInoYqVh5wFEbw4A5pBDIKktNzP+TJ4EyV1iVwNypY2O7b+sucavJYNFXEFndSA==
X-Received: by 2002:a17:90b:530f:b0:325:6598:30e5 with SMTP id 98e67ed59e1d1-325659833damr21695495a91.23.1756349893809;
        Wed, 27 Aug 2025 19:58:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7704821293asm13299794b3a.15.2025.08.27.19.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 19:58:13 -0700 (PDT)
Message-ID: <8f4a4090-78ed-4cf1-bd73-7ae73fff8b90@kernel.dk>
Date: Wed, 27 Aug 2025 20:58:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
From: Jens Axboe <axboe@kernel.dk>
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: aftern00n@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8abaf4ad-d457-422d-9e9e-932cab2588e6@kernel.dk>
 <tencent_87B68C160DC3F4AE06BD6DF0349B1B235E05@qq.com>
 <8ed15a17-618f-4277-afc3-934939292060@kernel.dk>
Content-Language: en-US
In-Reply-To: <8ed15a17-618f-4277-afc3-934939292060@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 8:50 PM, Jens Axboe wrote:
> On 8/27/25 8:49 PM, Qingyue Zhang wrote:
>> On Wed, 27 Aug 2025 20:08:05 -0600, Jens Axboe wrote:
>>> I don't think there's anything wrong with the looping and stopping at
>>> the other end is of course a safe guard, but couldn't we just abort the
>>> loop if we see a 0 sized buffer? At that point we know the buffer is
>>> invalid, or the kernel is buggy, and it'd be saner to stop at that
>>> point. Something ala:
>>>
>>>
>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>> index 394037d3f2f6..19a8bde5e1e1 100644
>>> --- a/io_uring/kbuf.c
>>> +++ b/io_uring/kbuf.c
>>> @@ -42,7 +42,8 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>>  		buf_len = READ_ONCE(buf->len);
>>>  		this_len = min_t(u32, len, buf_len);
>>>  		buf_len -= this_len;
>>> -		if (buf_len) {
>>> +		/* Stop looping for invalid buffer length of 0 */
>>> +		if (buf_len || !this_len) {
>>>  			buf->addr += this_len;
>>>  			buf->len = buf_len;
>>>  			return false;
>>
>> Good idea, it looks nice to me.
> 
> I'll send it out, I amended the commit message a bit too.

Oh, and let me know if you prefer any tags or whatever changed in that
patch.

Additionally, would you mind if I use your reproducer for a test case?
I turned it into the below. Will need a bit more to be a test case, but
it's pretty much there. Functionally it should be the same, it's just
using more idiomatic liburing rather than the lower level helpers.

And finally, thanks for the report and test case! Very useful.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <liburing.h>

#define BGID		0
#define RENTRIES	2
#define RMASK		(RENTRIES - 1)

int main(int argc, char *argv[])
{
	struct io_uring_buf_ring *br;
	struct io_uring_sqe *sqe;
	struct io_uring ring;
	void *send_buf;
	int ret, fds[2];

	io_uring_queue_init(1, &ring, IORING_SETUP_NO_SQARRAY);

	br = io_uring_setup_buf_ring(&ring, RENTRIES, BGID, IOU_PBUF_RING_INC, &ret);
	if (!br) {
		if (ret == -EINVAL)
			return 77;
		fprintf(stderr, "buf ring setup: %d\n", ret);
		return 1;
	}

	/*
	 * Use the buffer ring itself as the provided buffer address. Once the
	 * recv completes, it will have zero filled the buffer addr/len.
	 */
	io_uring_buf_ring_add(br, br, 4096, 0, RMASK, 0);
	io_uring_buf_ring_advance(br, 1);

	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, fds) < 0) {
		perror("socketpair");
		return 1;
	}

	/*
	 * Send zeroes, overwriting the buffer ring
	 */
	send_buf = calloc(1, 32);
	ret = send(fds[0], send_buf, 32, MSG_DONTWAIT);
	if (ret < 0) {
		perror("send");
		return 1;
	}

	/*
	 * Do recv, picking the first buffer. When buffer is picked,
	 * it's still fully valid. By the time it needs to get committed,
	 * it will have invalid addr/len fields (all zeroes from the recv)
	 */
	sqe = io_uring_get_sqe(&ring);
	io_uring_prep_recv_multishot(sqe, fds[1], NULL, 0, 0);
	sqe->flags |= IOSQE_BUFFER_SELECT;
	sqe->buf_index = BGID;
	io_uring_submit_and_wait(&ring, 2);

	io_uring_free_buf_ring(&ring, br, RENTRIES, BGID);
	io_uring_queue_exit(&ring);
	return 0;
}

-- 
Jens Axboe

