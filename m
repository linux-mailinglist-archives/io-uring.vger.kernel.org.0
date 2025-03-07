Return-Path: <io-uring+bounces-6978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDD4A569FB
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 262DE3A79B4
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 14:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5930621C187;
	Fri,  7 Mar 2025 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIxwNx/9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0CF21C179
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741356418; cv=none; b=rG2qfF7rfwZD7qS7gzCLhUsreCs5dwy/Ou7tQYJPfc/khiBZr+iZYodNM+5olt0MHLh7qNnjq/utyoUw06F22CD+OfUKK3PVYFtaKF/J00F7HBSUI3h6Mqknw+7OP012pbkYaEeNQMW5NNmUiChT66cP5Hs8+lHila3RI6cmJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741356418; c=relaxed/simple;
	bh=Jll6oVwM31Ylxan2KUku6hT3yVLswbrQr8K46dOgOTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNQv70uh6H3sBXwHVE4WGlrB+dppLsTDFD7J3PzrVV3WDea5tyhIWMcLTlp904kwWOgUHOdhD5YvxHr8+Vrs7kG8Af44n8prnJj7AMj0y4jzgq64g/uSjq3fezNrcd6zH+TDtyS3Xk4RMcY8qu5IbU2XinoOdT7bjFeuglxDN4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIxwNx/9; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac25313ea37so172737466b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 06:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741356414; x=1741961214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epCtH7q9kgGYAX/4kN7gsjtEYtWjc3LM84Z8/BYUZqA=;
        b=SIxwNx/9sz72Mnu3DvaclIlbox1LZ3fDt30pcpsOeZlpynzoTNGhcfU6Z9xFReFbnM
         HwdZHHU4xg+OcHWrmVWS1W4LcykRdcB1KaAbtvd7ryH4dAjcZyUqHij7pn8qtXiuF49R
         r4A4CR76IoLrv4BCylfFGVqYFuMw2qks1NmaX10GzQMIIYBLpIRc69xC/S78R8EoucFM
         T0kMH/SIWwEFwBdeIoVHsRSl+3THAsQ+6k4IIJd8LWtv4hPbfQC5XB5JCO4wxvBOEhC/
         bwb2nKEw9rPzedvB32KAd14WW+FXQagVp2bsodVhtavg7jY6CVMFHkem3bh8viBDBk6U
         BGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741356414; x=1741961214;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epCtH7q9kgGYAX/4kN7gsjtEYtWjc3LM84Z8/BYUZqA=;
        b=rfs5Vj3+uPG7PJRiidy5U3cwgvt4StmfwcmWvIz6zxVT+TKKZ7k+bvfOe5npgp0ywJ
         pZpkcbIyJgBNvnlBTWBfD8J5rQbf2gGObWoDjWMEYdEpby7/UpCbk4CjBMT6CoeITwNt
         UhKEzc29v80UbPyqUMXThrRLPhE+3VZ+cABpmsRZwrNjoVE5K6+R0Ef216dXWKE1RJ1g
         WyVdMgtVWrxnbbLDXqnY/51zbrSvkhFseuFpzHCXlAn5pnpTbcwcV6xuaEU19dHuaGKB
         NhfuMajc1J/+IUAMQgskxPursuQc/7SZBdRxZqUZGZNegotYTasnuBa/hRYVTEhSefMi
         n+bQ==
X-Gm-Message-State: AOJu0Yz+7lU4JgSDQ9EQanTRb7LLk33Ibfuum8yb9tLs04cpw28HMc/S
	acSLRdYNsIt7baeZth59IM1fbbNnGq5mXuN6f7fP4C4CJ+qcR0Yami4tpg==
X-Gm-Gg: ASbGncv4BTe1Vdb714yDGkrDmxDLbxCsLrBI047QaA3BUzUZFV4KNORkDTHlJJqjr3L
	m+nvfwlfOQxxBCJNdYSdPGl48pzZJbJm9XPLkJmccNq7tDSKMH1diPMRtm1ZeoJp2e3dY4S3er8
	1gat0IOsCLPGQGMX7PLVqJZpWrswjA+JLzgx5wHZjP3Vey1yuq/WPe1S6AWU/XAfaqtejDPpKEd
	6XrLi+1c4HdX78Z+4m6i3ZrcOAZXZHjogZrMTcZoG+sjIBEj697bK0+pJhX7xsxjKezUMGF/bGY
	Ij39+kbfdT74UyGHUw5jnDfsRG8BmNX/dM1fCgeN8BmsBJ/+au2wY9A+HhhRJTNIYps69w6iQlP
	EGg==
X-Google-Smtp-Source: AGHT+IGve5errBRcpdoE2wLSnAwp5YjvODCFEc/m0GWMnpmQ1Q8jjUxPD+Z1Um2qiyyzKSycYJniBw==
X-Received: by 2002:a17:907:3f2a:b0:abf:6e3b:4b4 with SMTP id a640c23a62f3a-ac25265999emr372377866b.22.1741356413986;
        Fri, 07 Mar 2025 06:06:53 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2394894cbsm284379266b.70.2025.03.07.06.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 06:06:53 -0800 (PST)
Message-ID: <75fb61af-0ace-4e2d-ae4d-66573c4a63b8@gmail.com>
Date: Fri, 7 Mar 2025 14:07:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] io_uring: add infra for importing vectored reg
 buffers
To: io-uring@vger.kernel.org
Cc: Andres Freund <andres@anarazel.de>
References: <cover.1741102644.git.asml.silence@gmail.com>
 <b054a88092767f7767f8447e7a5bdab15fcc0759.1741102644.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b054a88092767f7767f8447e7a5bdab15fcc0759.1741102644.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 15:40, Pavel Begunkov wrote:
> Add io_import_reg_vec(), which will be responsible for importing
> vectored registered buffers. iovecs are overlapped with the resulting
> bvec in memory, which is why the iovec is expected to be padded in
> iou_vec.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
...
> +int io_import_reg_vec(int ddir, struct iov_iter *iter,
> +			struct io_kiocb *req, struct iou_vec *vec,
> +			unsigned nr_iovs, unsigned iovec_off,
> +			unsigned issue_flags)
> +{
> +	struct io_rsrc_node *node;
> +	struct io_mapped_ubuf *imu;
> +	struct iovec *iov;
> +	unsigned nr_segs;
> +
> +	node = io_find_buf_node(req, issue_flags);
> +	if (!node)
> +		return -EFAULT;
> +	imu = node->buf;
> +	if (imu->is_kbuf)
> +		return -EOPNOTSUPP;
> +	if (!(imu->dir & (1 << ddir)))
> +		return -EFAULT;
> +
> +	iov = vec->iovec + iovec_off;
> +	nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);

if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
	size_t entry_sz = sizeof(struct iovec);
	size_t bvec_bytes = nr_segs * sizeof(struct bio_vec);
	size_t iovec_off = (bvec_bytes + entry_sz - 1) / entry_sz;

	nr_segs += iovec_off;
}

How about fixing it up like this for now? Instead of overlapping
bvec with iovec, it'd put them back to back and waste some memory
on 32bit.

I can try to make it a bit tighter, remove the if and let
the compiler to optimise it into no-op for x64, or allocate
max(bvec, iovec) * nr and see where it leads. But in either
way IMHO it's better to be left until I get more time.


> +
> +	if (WARN_ON_ONCE(iovec_off + nr_iovs != vec->nr) ||
> +	    nr_segs > vec->nr) {
> +		struct iou_vec tmp_vec = {};
> +		int ret;
> +
> +		ret = io_vec_realloc(&tmp_vec, nr_segs);
> +		if (ret)
> +			return ret;
> +
> +		iovec_off = tmp_vec.nr - nr_iovs;
> +		memcpy(tmp_vec.iovec + iovec_off, iov, sizeof(*iov) * nr_iovs);
> +		io_vec_free(vec);
> +
> +		*vec = tmp_vec;
> +		iov = vec->iovec + iovec_off;
> +		req->flags |= REQ_F_NEED_CLEANUP;
> +	}
> +
> +	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
> +}


-- 
Pavel Begunkov


