Return-Path: <io-uring+bounces-155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6337F9FC5
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 13:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38C9B280F42
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 12:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF0B18C3A;
	Mon, 27 Nov 2023 12:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nn1Ib4dQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3111E18A;
	Mon, 27 Nov 2023 04:40:36 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40b473cccfbso5150875e9.0;
        Mon, 27 Nov 2023 04:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701088834; x=1701693634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rlkG+ORnNzrHAbs39K++cguO3aQRZiNviG0OFgw1R+w=;
        b=nn1Ib4dQkV56Hr5vINPhnHRZ6h84klWfMZZtlQOWu//BlcZ/5WmbpvV1v/dPrM+WXi
         QLR8WzE+AAwzJKrFAeAmBmOLnyuRzjjRuR/gH36amMkyKiPG9rtiYiUTXztrHrq8df9t
         UPjBjNv6uZfvcQbrObl+e8egoeNfUgDK6EgeI6oV3fk+evdQ/3LIE3Y4uG0NiXk8DDuu
         t19cdkfgW7noWzAKccMTAE0ETGaYnseQ9FHppEG+i/IPluuOBeseWk5j5A9bsKKvstd5
         oWHkVvoRaRhUKdzW09KXx8hzLM42YSg2Ab8rztfdbaGs8W2/8ku7KoZSHLajw0mpyGq5
         ZKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701088834; x=1701693634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rlkG+ORnNzrHAbs39K++cguO3aQRZiNviG0OFgw1R+w=;
        b=sEa9w9HUEpk3/Xeb9+ugdA3TA5azEvFRB6O3NcheW72XpmRkRYhxbpX3zGlNjxiGAn
         uBNDV1DfzEDAcQAEYAkKGUAYhjaoaO0q8oPagMLzE+zVUshmDIw5RF5QvvW+fPA0Fd6O
         d5EzBlFpZFj+dpgiDHJP1H8gBQfuCYq1TPq5JOh+n0Hxon2wyy9DLUUufBQV1sUX8IgG
         FYxVWOW4e44QeIbBOtVdpI8KXk4SGEKNUA4EvwhAGZoxKlDpiNzeSuIvQsWuoO0y/Gfe
         eXBDG54/O7ux0m18v5tOvSAsbeKDuNk3JgD6Z+CQhFqnv5Jwk4cIg+qoau/jw6ygC5tf
         /sBg==
X-Gm-Message-State: AOJu0YxSGCh7poyfJwlBfUpcDbhrOlInWo83p3ZM1wuL4xUdTAwVsk15
	1JohUojCtpo022vZgqHaDxM=
X-Google-Smtp-Source: AGHT+IH8vGwwkQ3464c5zeo6fTTxe1SuxrfuBUm/Bv2Sb0taSA3dGc0pWFedLf1KbekZbK/RSfkI7Q==
X-Received: by 2002:a05:600c:1f8c:b0:40b:2baa:6a0d with SMTP id je12-20020a05600c1f8c00b0040b2baa6a0dmr4100969wmb.1.1701088834100;
        Mon, 27 Nov 2023 04:40:34 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:8abd])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c470c00b0040b397787d3sm11287878wmo.24.2023.11.27.04.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 04:40:33 -0800 (PST)
Message-ID: <0672bf8f-92e2-4984-9d69-852b47481013@gmail.com>
Date: Mon, 27 Nov 2023 12:33:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 net-next 2/4] af_unix: Return struct unix_sock from
 unix_get_socket().
To: Paolo Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: Ivan Babrou <ivan@cloudflare.com>, Kuniyuki Iwashima
 <kuni1840@gmail.com>, netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20231123014747.66063-1-kuniyu@amazon.com>
 <20231123014747.66063-3-kuniyu@amazon.com>
 <df0620741383dd4506d478a5a7adcb8b8f63fd67.camel@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <df0620741383dd4506d478a5a7adcb8b8f63fd67.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/23 09:08, Paolo Abeni wrote:
> On Wed, 2023-11-22 at 17:47 -0800, Kuniyuki Iwashima wrote:
>> Currently, unix_get_socket() returns struct sock, but after calling
>> it, we always cast it to unix_sk().
>>
>> Let's return struct unix_sock from unix_get_socket().
>>
>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>> ---
>>   include/linux/io_uring.h |  4 ++--
>>   include/net/af_unix.h    |  2 +-
>>   io_uring/io_uring.c      |  5 +++--
>>   net/unix/garbage.c       | 19 +++++++------------
>>   net/unix/scm.c           | 26 +++++++++++---------------
>>   5 files changed, 24 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>> index aefb73eeeebf..be16677f0e4c 100644
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>> @@ -54,7 +54,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>   			      struct iov_iter *iter, void *ioucmd);
>>   void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
>>   			unsigned issue_flags);
>> -struct sock *io_uring_get_socket(struct file *file);
>> +struct unix_sock *io_uring_get_socket(struct file *file);
>>   void __io_uring_cancel(bool cancel_all);
>>   void __io_uring_free(struct task_struct *tsk);
>>   void io_uring_unreg_ringfd(void);
>> @@ -111,7 +111,7 @@ static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>>   			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>   {
>>   }
>> -static inline struct sock *io_uring_get_socket(struct file *file)
>> +static inline struct unix_sock *io_uring_get_socket(struct file *file)
>>   {
>>   	return NULL;
>>   }
>> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
>> index 5a8a670b1920..c628d30ceb19 100644
>> --- a/include/net/af_unix.h
>> +++ b/include/net/af_unix.h
>> @@ -14,7 +14,7 @@ void unix_destruct_scm(struct sk_buff *skb);
>>   void io_uring_destruct_scm(struct sk_buff *skb);
>>   void unix_gc(void);
>>   void wait_for_unix_gc(void);
>> -struct sock *unix_get_socket(struct file *filp);
>> +struct unix_sock *unix_get_socket(struct file *filp);
>>   struct sock *unix_peer_get(struct sock *sk);
>>   
>>   #define UNIX_HASH_MOD	(256 - 1)
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ed254076c723..daed897f5975 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -177,13 +177,14 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
>>   };
>>   #endif
>>   
>> -struct sock *io_uring_get_socket(struct file *file)
>> +struct unix_sock *io_uring_get_socket(struct file *file)
>>   {
>>   #if defined(CONFIG_UNIX)
>>   	if (io_is_uring_fops(file)) {
>>   		struct io_ring_ctx *ctx = file->private_data;
>>   
>> -		return ctx->ring_sock->sk;
>> +		if (ctx->ring_sock->sk)
>> +			return unix_sk(ctx->ring_sock->sk);
>>   	}
>>   #endif
>>   	return NULL;
>> diff --git a/net/unix/garbage.c b/net/unix/garbage.c
>> index db1bb99bb793..4d634f5f6a55 100644
>> --- a/net/unix/garbage.c
>> +++ b/net/unix/garbage.c
>> @@ -105,20 +105,15 @@ static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
>>   
>>   			while (nfd--) {
>>   				/* Get the socket the fd matches if it indeed does so */
>> -				struct sock *sk = unix_get_socket(*fp++);
>> +				struct unix_sock *u = unix_get_socket(*fp++);
>>   
>> -				if (sk) {
>> -					struct unix_sock *u = unix_sk(sk);
>> +				/* Ignore non-candidates, they could have been added
>> +				 * to the queues after starting the garbage collection
>> +				 */
>> +				if (u && test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
>> +					hit = true;
>>   
>> -					/* Ignore non-candidates, they could
>> -					 * have been added to the queues after
>> -					 * starting the garbage collection
>> -					 */
>> -					if (test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
>> -						hit = true;
>> -
>> -						func(u);
>> -					}
>> +					func(u);
>>   				}
>>   			}
>>   			if (hit && hitlist != NULL) {
>> diff --git a/net/unix/scm.c b/net/unix/scm.c
>> index 4b3979272a81..36ce8fed9acc 100644
>> --- a/net/unix/scm.c
>> +++ b/net/unix/scm.c
>> @@ -21,9 +21,8 @@ EXPORT_SYMBOL(gc_inflight_list);
>>   DEFINE_SPINLOCK(unix_gc_lock);
>>   EXPORT_SYMBOL(unix_gc_lock);
>>   
>> -struct sock *unix_get_socket(struct file *filp)
>> +struct unix_sock *unix_get_socket(struct file *filp)
>>   {
>> -	struct sock *u_sock = NULL;
>>   	struct inode *inode = file_inode(filp);
>>   
>>   	/* Socket ? */
>> @@ -34,12 +33,13 @@ struct sock *unix_get_socket(struct file *filp)
>>   
>>   		/* PF_UNIX ? */
>>   		if (s && ops && ops->family == PF_UNIX)
>> -			u_sock = s;
>> -	} else {
>> -		/* Could be an io_uring instance */
>> -		u_sock = io_uring_get_socket(filp);
>> +			return unix_sk(s);
>> +
>> +		return NULL;
>>   	}
>> -	return u_sock;
>> +
>> +	/* Could be an io_uring instance */
>> +	return io_uring_get_socket(filp);
>>   }
>>   EXPORT_SYMBOL(unix_get_socket);
>>   
>> @@ -48,13 +48,11 @@ EXPORT_SYMBOL(unix_get_socket);
>>    */
>>   void unix_inflight(struct user_struct *user, struct file *fp)
>>   {
>> -	struct sock *s = unix_get_socket(fp);
>> +	struct unix_sock *u = unix_get_socket(fp);
>>   
>>   	spin_lock(&unix_gc_lock);
>>   
>> -	if (s) {
>> -		struct unix_sock *u = unix_sk(s);
>> -
>> +	if (u) {
>>   		if (!u->inflight) {
>>   			BUG_ON(!list_empty(&u->link));
>>   			list_add_tail(&u->link, &gc_inflight_list);
>> @@ -71,13 +69,11 @@ void unix_inflight(struct user_struct *user, struct file *fp)
>>   
>>   void unix_notinflight(struct user_struct *user, struct file *fp)
>>   {
>> -	struct sock *s = unix_get_socket(fp);
>> +	struct unix_sock *u = unix_get_socket(fp);
>>   
>>   	spin_lock(&unix_gc_lock);
>>   
>> -	if (s) {
>> -		struct unix_sock *u = unix_sk(s);
>> -
>> +	if (u) {
>>   		BUG_ON(!u->inflight);
>>   		BUG_ON(list_empty(&u->link));
>>   
> 
> Adding the io_uring peoples to the recipient list for awareness. I
> guess this deserves an explicit ack from them.

Thanks Paolo, lgtm

Acked-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

