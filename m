Return-Path: <io-uring+bounces-12739-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHRGH/EFumlcQgIAu9opvQ
	(envelope-from <io-uring+bounces-12739-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 02:54:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E6F2B50E6
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 02:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A419F304075F
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 01:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D963E242D86;
	Wed, 18 Mar 2026 01:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WkMSzFdb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9361B4F09
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773798828; cv=none; b=tn/7UgpMFdMKYBaC2DXZ4DIRu3CsvJDgsbgeq6PlH3Iuebqjxb3XkIr4XI5rqVNCD3I7JVgnniUfzCp8uhyEeR+n6skWFUyzAOJBcDRaSJRkFiIr81WBk+ka98V4RSztEiP5lddahP1DYQ0Cq8DrYYbOH8yDVP/H75+yo6dLa4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773798828; c=relaxed/simple;
	bh=5pxaOMozqi+U1L9wQC+eh3K99tLwoa1nEZUEmGVk9j0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t48DIwv3TvwSRnT0HNTedEydKzW0L9aML+iQfgsrbKXm7efzlxaGXf/Xt9PeUMpYxCPMRecauCN7ESQLXmeIRXZ7J2+7HGxZx8ydNlFnD4xM+CygBLJnE0gY9KDyRC4mNqxQVzRC86KTrnx/iTjebzpTCpqtsbUJ1oNsudbSz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WkMSzFdb; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d743cd9e5bso150362a34.2
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 18:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773798826; x=1774403626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sgb5BhT3xmKc+VcLKBubloVcdYOT6b+LpfgZfEBHMG4=;
        b=WkMSzFdbF9G8qFmp7JZMOkSyD8rAArZpj3qMcYFYdrqqtitop90bwfyTU06AdcQkVT
         rvTUeH0jDrOMwRKVudDGLYU2tFmUQ5z64/jXMYhFPvgnv3UP2LtZLGj3vUS99Ki7oQbm
         0eg4GWeHaCWCASvea3Hc4W1TbEikeioSZyA2S3f1kybjfwasVp2ZI4ORs7agBilPSC94
         X3my9fBqhAKa9KTtGIaNTlZObc/c+xWhQQivwCG+UKWw6e8YIFjIAQ5qzGbfp0HsqUKP
         Z4T7eyfup8iApiKiYhVeO9JiFHCgDlAF2J7No6pjswe+4Cgno9iiN3R9SOZen6xqEWao
         hKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773798826; x=1774403626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sgb5BhT3xmKc+VcLKBubloVcdYOT6b+LpfgZfEBHMG4=;
        b=bPCRebQCF1JosYtyBgom+59ontsisyqMNi2tRd95LRj+tPVRes3DKtaOvFAqSKUFTt
         GZsv+dnz8c7g1ToOlHp/ga/2Rl6SzebXMRJuTMfIfEOXCiBAgeOwTtOMMPS0K9Ddnnlw
         p83nF49NoyTSAf5PyDU9t25n5qFEUjI5m9kYbc5W6xNiDrvTWZ140xNF/6xtthKmSbxU
         b2Qw64O5jGCOVIXiRWFpVvgTWHFvLY+F5J/MGJ+5b/hGsxAX8mn/PGWLyXAlVmfxacTV
         yNJZHxamexxDnqLegPR9PMA5dofL051HE54D6Ozqp8Z4H8jcbgRT9qc2zWtfqBsWv1rF
         mOxA==
X-Forwarded-Encrypted: i=1; AJvYcCUJzg14iE1h3RoBQ1NtbNCA/6miiqlTs4yzLgWyGJD0pDuVn9ITWC9pSqnJTtFeUsNH4H0mxMuukQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBV23Zpw9aIgh7enFSLVzuyHGhryXjfdl6totQubbh/dMkUSFX
	iYuCCCWte+W3OTnmBwbSpg0VEj7sxndrMLWSv7ZdPhwh0WK3GW2OW3vqH0ihNVSfa8Q=
X-Gm-Gg: ATEYQzy6o1R2WdMVCFYEJLhGcW4S5iWIyTnG4xvDvMY+RX/4xnFsReGn8/Mh/DpqOeh
	PSKqtLThPb5IGnopcH8YxrOyypYoDRgOgji6TrRJHoaXkGA5HiDkFCIEi3bKoZLzZ2+zRnVd4sh
	LMjXwhCJ7KH1/jW25Z5DIV9RvCglK7RBneKfi5iWHyfgS5VW8rDO1nR6FU1NF1uA5ONYzVK0eDn
	y3a7rf1HRf2y7ckKfb4d+7G04o7BRLz/+dd6u6mHyXZG8ljFv7/GLiPybh+BNJFxbtE+zJCoan/
	LwbPnf0/AOJPiKPZogvtWmdC+H2ctL+cJJJuEJp1ve8z0khWHYn3DhlA3mPrLQhf/OS035Afg0I
	CYNPxavR6M0M1JiU/FQoQ0iQw2KC1NCvS+qIlOyZ++tX55LSigcxuJl0sjUCUVjYGVQ8kgsFN4E
	VDwvuaM9FTQfNd6wat7g7k5wnPQ7O3wyWVN+S8c2FFHEyB1sZtn/SG9VWSF8DKDn8PqZKG4wR6E
	TU7ZSp4mg==
X-Received: by 2002:a05:6830:498b:b0:7d4:96c3:3f97 with SMTP id 46e09a7af769-7d7ca566cf8mr1223594a34.2.1773798825772;
        Tue, 17 Mar 2026 18:53:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9b3696asm1102397a34.16.2026.03.17.18.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 18:53:45 -0700 (PDT)
Message-ID: <9f08ade1-ca61-4ba3-9d1e-744ea5e8c004@kernel.dk>
Date: Tue, 17 Mar 2026 19:53:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test io_uring bpf ops
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <818dcda223b3288c764367cb0ab8d57c83722d78.1772109275.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <818dcda223b3288c764367cb0ab8d57c83722d78.1772109275.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12739-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D0E6F2B50E6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2/26/26 5:49 AM, Pavel Begunkov wrote:
> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
> a loop, the other copies a file. It needs appropriate tools for bpf and
> hence is gated on a BPF_TESTS make flag for now.

None of this ends up getting compiled... Can we add a configure test for
this too, I suspect most of it should be there already in terms of
liburing supporting the cbpf filters.

-- 
Jens Axboe


