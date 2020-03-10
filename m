Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9322D17FEC2
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 14:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgCJNhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 09:37:47 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:37946 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgCJNhr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 09:37:47 -0400
Received: by mail-il1-f196.google.com with SMTP id f5so11990624ilq.5
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 06:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGu+OwF+yEtIQrbyfZslkshAMLQbOetvyiJ8PNEQrcg=;
        b=B0XQtAF4Lul7A32Vh4Mfw9fMzQo6i2QyK/VcKUJ0NAQRcLQ1Kirt1XTrfGA7pbHvLo
         /Gg3x4W8zq+ADOvbDeTl3Zmw/CoPiIjeUa+NeLCGwcvi3Vy5TAza5DqihZ5n9qOXQ0PB
         BZTc9tWga8eOWWY4158LqZx6wyjtBKMysJTSouV2ygVADVN4CBETZZAPBOCFjem/cAMo
         yF7v2GRkbin+yL3h6OQMbCgBw2QFfZ6oI7OvVwsmm+WsaVPtmDU2PeWnptME5pcvqOAq
         LjwTNPfO0lg1QSIVnwQsdqSUOtiQEEXmGRBnTRZWRgp/xzOl1YmxcEX06d3ivnkYC2JX
         +CIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGu+OwF+yEtIQrbyfZslkshAMLQbOetvyiJ8PNEQrcg=;
        b=QajI6qqXU7ouZfOdOp8wAAdIjquNr9cBzB8fNWDPIf5//plyBSVsjAsCVO8DcIAaZd
         b6CKJ2ce3aiA0izZs61uRMBftBsVh+W9tOncnXB6yicJVDm1rTyo0hglR0/CpJungrii
         cvX3oAwx/q6r38SQuIR3Yf/OV2tc4yx4s6FPYi93dmRXi5hVRNJapLsUC3pVDiYHo1+9
         NCYaNZlBo1Bz5FyZKwGLQwJ5e5DzOZsu0R1d9z4n3exLcrmXgJZ9OXazOypIpcKX2Wuf
         UoGs5SziB1RbF0QLQuNjYcDx4WRqxNC2v6DxOva7Ktr0d7TwUOBx+eGXjnvGT2dfMMaE
         8c1g==
X-Gm-Message-State: ANhLgQ3mNunQj/XiCP7uU75ME4oJHJcM+Rr/bgpN2yIC2ug/u71XFQWl
        39ZzlvP6/l6NdW7VpUkq7H37qgN2/E0/kQ==
X-Google-Smtp-Source: ADFU+vveQ0B/2J/ZdDd8SlgOLAbhs93wmXIx7cAEdp7v0HsI9+vKQq977VnMKMMpGz0k6XsMF1dTQQ==
X-Received: by 2002:a92:1a12:: with SMTP id a18mr20230058ila.10.1583847466224;
        Tue, 10 Mar 2020 06:37:46 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j81sm10444142ilg.15.2020.03.10.06.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 06:37:45 -0700 (PDT)
Subject: Re: [PATCH 3/6] io_uring: support buffer selection
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-4-axboe@kernel.dk>
 <20200309172101.lgswlmmt763jtuno@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82a0f0f9-977a-c131-e77a-289f3db4d48d@kernel.dk>
Date:   Tue, 10 Mar 2020 07:37:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309172101.lgswlmmt763jtuno@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 11:21 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-28 13:30:50 -0700, Jens Axboe wrote:
>> If a server process has tons of pending socket connections, generally
>> it uses epoll to wait for activity. When the socket is ready for reading
>> (or writing), the task can select a buffer and issue a recv/send on the
>> given fd.
>>
>> Now that we have fast (non-async thread) support, a task can have tons
>> of pending reads or writes pending. But that means they need buffers to
>> back that data, and if the number of connections is high enough, having
>> them preallocated for all possible connections is unfeasible.
>>
>> With IORING_OP_PROVIDE_BUFFERS, an application can register buffers to
>> use for any request. The request then sets IOSQE_BUFFER_SELECT in the
>> sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
>> a free buffer from the specified group is selected. If none are
>> available, the request is terminated with -ENOBUFS. If successful, the
>> CQE on completion will contain the buffer ID chosen in the cqe->flags
>> member, encoded as:
>>
>> 	(buffer_id << IORING_CQE_BUFFER_SHIFT) | IORING_CQE_F_BUFFER;
>>
>> Once a buffer has been consumed by a request, it is no longer available
>> and must be registered again with IORING_OP_PROVIDE_BUFFERS.
>>
>> Requests need to support this feature. For now, IORING_OP_READ and
>> IORING_OP_RECV support it. This is checked on SQE submission, a CQE with
>> res == -EINVAL will be posted if attempted on unsupported requests.
> 
> Why not EOPNOTSUPP or such? Makes it more feasible for applications to
> handle the case separately.

Good point, I can make that change.

>> +static int io_rw_common_cflags(struct io_kiocb *req)
>> +{
>> +	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
>> +	int cflags;
>> +
>> +	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
>> +	cflags |= IORING_CQE_F_BUFFER;
>> +	req->rw.addr = 0;
>> +	kfree(kbuf);
>> +	return cflags;
>> +}
> 
>>  		if (refcount_dec_and_test(&req->refs) &&
>> @@ -1819,13 +1860,16 @@ static inline void req_set_fail_links(struct io_kiocb *req)
>>  static void io_complete_rw_common(struct kiocb *kiocb, long res)
>>  {
>>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>> +	int cflags = 0;
>>  
>>  	if (kiocb->ki_flags & IOCB_WRITE)
>>  		kiocb_end_write(req);
>>  
>>  	if (res != req->result)
>>  		req_set_fail_links(req);
>> -	io_cqring_add_event(req, res);
>> +	if (req->flags & REQ_F_BUFFER_SELECTED)
>> +		cflags = io_rw_common_cflags(req);
>> +	__io_cqring_add_event(req, res, cflags);
>>  }
> 
> Besides the naming already commented upon by Pavel, I'm also wondering
> if it's the right thing to call this unconditionally from
> io_complete_*rw*_common() - hard to see how this feature would ever be
> used in the write path...

Doesn't really matter I think, I'd rather have that dead branch for
writes than needing a separate handler. I did change the naming, this
posting is almost two weeks old. I'll change the other little bits from
here and post a new series so we're all on the same page.

>> +static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
>> +					  struct io_buffer *kbuf,
>> +					  bool needs_lock)
>> +{
>> +	struct list_head *list;
>> +
>> +	if (req->flags & REQ_F_BUFFER_SELECTED)
>> +		return kbuf;
>> +
>> +	/*
>> +	 * "Normal" inline submissions always hold the uring_lock, since we
>> +	 * grab it from the system call. Same is true for the SQPOLL offload.
>> +	 * The only exception is when we've detached the request and issue it
>> +	 * from an async worker thread, grab the lock for that case.
>> +	 */
>> +	if (needs_lock)
>> +		mutex_lock(&req->ctx->uring_lock);
>> +
>> +	lockdep_assert_held(&req->ctx->uring_lock);
> 
> This comment is in a few places, perhaps there's a way to unify by
> placing the conditional acquisition into a helper?

We could have a io_lock_ring(ctx, force_nonblock) helper and just put it
in there, ditto for the unlock.

>> +	list = idr_find(&req->ctx->io_buffer_idr, gid);
>> +	if (list && !list_empty(list)) {
>> +		kbuf = list_first_entry(list, struct io_buffer, list);
>> +		list_del(&kbuf->list);
>> +	} else {
>> +		kbuf = ERR_PTR(-ENOBUFS);
>> +	}
>> +
>> +	if (needs_lock)
>> +		mutex_unlock(&req->ctx->uring_lock);
>> +
>> +	return kbuf;
>> +}
>> +
>>  static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>> -			       struct iovec **iovec, struct iov_iter *iter)
>> +			       struct iovec **iovec, struct iov_iter *iter,
>> +			       bool needs_lock)
>>  {
>>  	void __user *buf = u64_to_user_ptr(req->rw.addr);
>>  	size_t sqe_len = req->rw.len;
>> @@ -2140,12 +2219,30 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>>  		return io_import_fixed(req, rw, iter);
>>  	}
>>  
>> -	/* buffer index only valid with fixed read/write */
>> -	if (req->rw.kiocb.private)
>> +	/* buffer index only valid with fixed read/write, or buffer select  */
>> +	if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
>>  		return -EINVAL;
>>  
>>  	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
>>  		ssize_t ret;
>> +
>> +		if (req->flags & REQ_F_BUFFER_SELECT) {
>> +			struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
>> +			int gid;
>> +
>> +			gid = (int) (unsigned long) req->rw.kiocb.private;
>> +			kbuf = io_buffer_select(req, gid, kbuf, needs_lock);
>> +			if (IS_ERR(kbuf)) {
>> +				*iovec = NULL;
>> +				return PTR_ERR(kbuf);
>> +			}
>> +			req->rw.addr = (u64) kbuf;
>> +			if (sqe_len > kbuf->len)
>> +				sqe_len = kbuf->len;
>> +			req->flags |= REQ_F_BUFFER_SELECTED;
>> +			buf = u64_to_user_ptr(kbuf->addr);
>> +		}
> 
> Feels a bit dangerous to have addr sometimes pointing to the user
> specified data, and sometimes to kernel data. Even if indicated by
> REQ_F_BUFFER_SELECTED.

It's not ideal, but it's either that or have the struct io_rw blow over
the cacheline, which I don't want. So the tradeoff seemed like the right
one to me. All the initial io_kiocb per-request-type unions are 64b or
less.

>> +static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
>> +					       int *cflags, bool needs_lock)
>> +{
>> +	struct io_sr_msg *sr = &req->sr_msg;
>> +	struct io_buffer *kbuf;
>> +
>> +	if (!(req->flags & REQ_F_BUFFER_SELECT))
>> +		return NULL;
>> +
>> +	kbuf = io_buffer_select(req, sr->gid, sr->kbuf, needs_lock);
>> +	if (IS_ERR(kbuf))
>> +		return kbuf;
>> +
>> +	sr->kbuf = kbuf;
>> +	if (sr->len > kbuf->len)
>> +		sr->len = kbuf->len;
>> +	req->flags |= REQ_F_BUFFER_SELECTED;
>> +
>> +	*cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
>> +	*cflags |= IORING_CQE_F_BUFFER;
>> +	return kbuf;
>> +}
> 
> Could more of this be moved into io_buffer_select? Looks like every
> REQ_F_BUFFER_SELECT supporting op is going to need most of it?

Probably could be, I'll take a look and see if we can move more of that
logic in there.

>>  static int io_recvmsg_prep(struct io_kiocb *req,
>>  			   const struct io_uring_sqe *sqe)
>>  {
> 
> Looks like this would be unused if !defined(CONFIG_NET)?

Also fixed a week ago or so.

-- 
Jens Axboe

