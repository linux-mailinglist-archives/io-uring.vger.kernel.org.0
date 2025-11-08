Return-Path: <io-uring+bounces-10452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E22C42211
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 01:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A09A18988CD
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 00:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E363620C490;
	Sat,  8 Nov 2025 00:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0+8BrtkM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524420A5E5
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 00:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561654; cv=none; b=eDIq/z8oVAqXc9q4vgGvyf+BjUPTZLNH7sxCv4MqtUumMVxi/WtvAOmI8rpUJKq/TPPabXdIagTB/7h2nTPdyJp6sIdJUA2B2bdLJ9wxWlorfhRF+QEmf8RrB/AUSFkYbRscCZwVUEHcCCxxxpCcWKhXXYCzhJ3Th1GyiBT15go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561654; c=relaxed/simple;
	bh=rHCHWwzqzjD8rtUG/YpSaHpsP3JYyPZwIhvrQrJqxfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YM0FFpTyz2nCSQ97xuCfh7xwK+g+ZcCv8nhm/NnwDyTvkGeOLn44NdRHKeJBe+DRjwAmBqbDbIC5EpfKsXdFQXcGiTyRtnw9ARa1hOouPTFdBDFxQZ9VesycqaJQcusquCT5ZgRv0yklmMWeova7Mt+UT9YxRoc7Wr7lDQvodZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0+8BrtkM; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-89ed2ee35bbso171397885a.3
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 16:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762561651; x=1763166451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgriBR7EAEnHHgfHkgYfq8T8fPXYixpB1khtdTRZamE=;
        b=0+8BrtkMNwkzLHuJPBoi0TRcULpMre1PmQ2L3Y8dleC2z/UEgKL5CsH8BeY4muP+8Y
         PEzLYnLDNnom0Bfby2nWXdyp88TVl5MhezOlYSD9qXqieXYg/Ym3Id+Ri019E2kqXsgU
         uP2Yr5vjz3vi9lXjib66kud0gZsmmyIiL+jWUue7t+GmHESt3thyHn3JaUbhfGeLtO/d
         Kr1MMjSCmjtCI+fsQeUsZKyNLp7FLTNgXsGjJUk99E1XJ8m8f8i+zpeQpmlRgr9fQF8P
         UtVIxOakDwkpWw66pdszcR/2VFlqNyLG8SyrC44v2lotWGtb1xE8H1Yj0uNTWAOBZrND
         3/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762561651; x=1763166451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgriBR7EAEnHHgfHkgYfq8T8fPXYixpB1khtdTRZamE=;
        b=rvs188dzX3PNpFYgF6UUluJjgMgMnkDkB90QV8GPS3iG7JI/rU9Q138pMLah9Ms+J1
         ElO+/y0BZRy45BQbj+IsHmfPhWir3bO2hjGqyq2LMbMOp+oQF9982D9r9BF0TNqxVp4u
         EyUINIOAgRfy0QjtUc05R1HdipthPN/07kAT4Yz7outEy6W2VPv+aXMz9qBnaIIjt60A
         rGQ3sHCwx6IZw/wvH16iFsxn2kRFIDoTgaQgYQy49kWcN00krE0e8yZYErzTfnw+lVLU
         lqVMZveq8EhNWZI5R6gMttJIV32fqFeOC3pC+19Bn0r1+t9sbH58OdEm6i9yL/EsvoeC
         cuiA==
X-Forwarded-Encrypted: i=1; AJvYcCXMZBc0KbuMAPx2O8q/46q1jE0hGvfkVzKW15pCID7j4H34SXWjpgvU5tCTKHEzwrv1DcWesrfEIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjTQwSCn8JIFDdvBDy5bWvcfRHE1Cho9hKEQ2Z7p/Tk+BZFpCK
	eOfwOjoPZJuqNCVE5A6LktdvDO+KlyziBEp6masF6JHlPtVqGHKAyFKe2fW09NFRytFRGdIxuNo
	K55r0
X-Gm-Gg: ASbGncs4ZDqFOFURmWvxcj6UIdGLaI/fZ8uwSaQeq5PH/B2vUq3mPcaBU9cY+vCfKDN
	nCFiUSjMq4Tf0PdpVXx8SuRp5DOVso5Nw6EMGwhnCweD289im+Od/zeUO2P2FzEe6BaycUbI+OX
	imcjNH/YWShHUaX5C5o/4wK92dcT4AC0V1hx+hmZfWQPMDtSoNTb00OSEOy9PLAswN5OzEOQAl3
	uwgx+XoIWDRNWR9Bf7S/U5/9F7If3ObF6+mj+sM2sU2z3qbOtJ76yuYLm+hVPHRcc4moc6lIxlU
	V/wkXpTdwo9oc87W712oZa9Y72iAPigagho49zA568HmTW+XV00+igAlQNma8qZm6BCWQiIMQ3y
	fbsSEnOqD5+TerLbgsM+rcmBvbCF6STM6cjSaBeqtxJ/OUWnocjKmBwn2ISZ9UEgS4XtuoUVrDA
	65o2NSNc4=
X-Google-Smtp-Source: AGHT+IHIsKYdZdM3t7CvV/gxvRFv3QbidpHQTp+SrodUK06lsS4rlwofvdklkMBOD0ytxvjC//NPQQ==
X-Received: by 2002:a05:620a:17a3:b0:8a2:e35f:90 with SMTP id af79cd13be357-8b257ef5b97mr186170785a.30.1762561650959;
        Fri, 07 Nov 2025 16:27:30 -0800 (PST)
Received: from [10.0.0.167] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355c206fsm511249485a.5.2025.11.07.16.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 16:27:28 -0800 (PST)
Message-ID: <bffc5ed3-6b17-4119-af4c-1fdb51ea1b97@kernel.dk>
Date: Fri, 7 Nov 2025 17:27:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liburing: add test for metadata
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20251107042953.3393507-1-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251107042953.3393507-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/25 9:29 PM, Keith Busch wrote:
> +int main(int argc, char *argv[])
> +{
> +	int fd, ret, offset, intervals, metabuffer_size, metabuffer_tx_size;
> +	void *orig_data_buf, *orig_pi_buf, *data_buf;
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	struct io_uring ring;
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "Usage: %s <dev>\n", argv[0]);
> +		return T_EXIT_FAIL;
> +	}

This should be a T_EXIT_SKIP.

> +	fd = open(argv[1], O_RDWR | O_DIRECT);
> +	if (fd < 0) {
> +		perror("Failed to open device with O_DIRECT");
> +		return T_EXIT_FAIL;
> +	}
> +
> +	ret = init_capabilities(fd);
> +	if (ret < 0)
> +		return T_EXIT_FAIL;
> +	if (lba_size == 0 || metadata_size == 0)
> +		return T_EXIT_SKIP;
> +
> +	intervals = DATA_SIZE / lba_size;
> +	metabuffer_tx_size = intervals * metadata_size;
> +	metabuffer_size = metabuffer_tx_size * 2;
> +
> +	if (posix_memalign(&orig_data_buf, pagesize, DATA_SIZE)) {
> +		perror("posix_memalign failed for data buffer");
> +		ret = T_EXIT_FAIL;
> +		goto close;
> +	}
> +
> +	if (posix_memalign(&orig_pi_buf, pagesize, metabuffer_size)) {
> +		perror("posix_memalign failed for metadata buffer");
> +		ret = T_EXIT_FAIL;
> +		goto free;
> +	}
> +
> +	ret = io_uring_queue_init(8, &ring, 0);
> +	if (ret < 0) {
> +		perror("io_uring_queue_init failed");
> +		goto cleanup;
> +	}
> +
> +	data_buf = orig_data_buf;
> +	for (offset = 0; offset < 512; offset++) {
> +		void *pi_buf = (char *)orig_pi_buf + offset * 4;
> +		struct io_uring_attr_pi pi_attr = {
> +			.addr = (__u64)pi_buf,
> +			.seed = offset,
> +			.len = metabuffer_tx_size,
> +		};
> +
> +		if (reftag_enabled)
> +			pi_attr.flags = IO_INTEGRITY_CHK_REFTAG;
> +
> +		init_data(data_buf, offset);
> +		init_metadata(pi_buf, intervals, offset);
> +
> +		sqe = io_uring_get_sqe(&ring);
> +		if (!sqe) {
> +			fprintf(stderr, "Failed to get SQE\n");
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, offset * lba_size * 8);
> +		io_uring_sqe_set_data(sqe, (void *)1L);
> +
> +		sqe->attr_type_mask = IORING_RW_ATTR_FLAG_PI;
> +		sqe->attr_ptr = (__u64)&pi_attr;
> +
> +		ret = io_uring_submit(&ring);
> +		if (ret < 1) {
> +			perror("io_uring_submit failed (WRITE)");
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		ret = io_uring_wait_cqe(&ring, &cqe);
> +		if (ret < 0) {
> +			perror("io_uring_wait_cqe failed (WRITE)");
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		if (cqe->res < 0) {
> +			fprintf(stderr, "write failed at offset %d: %s\n",
> +				offset, strerror(-cqe->res));
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		io_uring_cqe_seen(&ring, cqe);
> +
> +		memset(data_buf, 0, DATA_SIZE);
> +		memset(pi_buf, 0, metabuffer_tx_size);
> +
> +		sqe = io_uring_get_sqe(&ring);
> +		if (!sqe) {
> +			fprintf(stderr, "failed to get SQE\n");
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		io_uring_prep_read(sqe, fd, data_buf, DATA_SIZE, offset * lba_size * 8);
> +		io_uring_sqe_set_data(sqe, (void *)2L);
> +
> +		sqe->attr_type_mask = IORING_RW_ATTR_FLAG_PI;
> +		sqe->attr_ptr = (__u64)&pi_attr;
> +
> +		ret = io_uring_submit(&ring);
> +		if (ret < 1) {
> +			perror("io_uring_submit failed (read)");
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		ret = io_uring_wait_cqe(&ring, &cqe);
> +		if (ret < 0) {
> +			fprintf(stderr, "io_uring_wait_cqe failed (read): %s\n", strerror(-ret));
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		if (cqe->res < 0) {
> +			fprintf(stderr, "read failed at offset %d: %s\n",
> +				offset, strerror(-cqe->res));
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		ret = check_data(data_buf, offset);
> +		if (ret) {
> +			fprintf(stderr, "data corruption at offset %d\n",
> +				offset);
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		ret = check_metadata(pi_buf, intervals, offset);
> +		if (ret) {
> +			fprintf(stderr, "metadata corruption at offset %d\n",
> +				offset);
> +			ret = T_EXIT_FAIL;
> +			goto ring_exit;
> +		}
> +
> +		io_uring_cqe_seen(&ring, cqe);
> +	}
> +
> +	memset(data_buf, 0, DATA_SIZE);
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, 0);
> +	io_uring_sqe_set_data(sqe, (void *)1L);
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_write(sqe, fd, data_buf, DATA_SIZE, DATA_SIZE);
> +	io_uring_sqe_set_data(sqe, (void *)2L);
> +
> +	io_uring_submit(&ring);
> +
> +	io_uring_wait_cqe(&ring, &cqe);
> +	io_uring_cqe_seen(&ring, cqe);
> +	io_uring_wait_cqe(&ring, &cqe);
> +	io_uring_cqe_seen(&ring, cqe);

This looks a bit odd - no error checking?

-- 
Jens Axboe

