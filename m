Return-Path: <io-uring+bounces-3959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF309ADBCB
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 08:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5BA31F224F6
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 06:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1805F174EEB;
	Thu, 24 Oct 2024 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gaBKK8zF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32B917BD3
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 06:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750430; cv=none; b=IGVaf8ZXb5BoJB43b/n/Ry0sICuV/OgG4blZF1PtpH/tKel/WRCbMPuIsNvYNrQ0hIzOohxNeTwfKMYqteZPIX8ahbwkVO3XmxZcx7Zey8st/LmyXL72d01KjvJ/325FwiK3cckoolwkcZqkgcOSKce956oqGwfeEVya0W9TalA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750430; c=relaxed/simple;
	bh=IgnmH2zlhXj7D09v/j5kD4MyGBPkUvzJ16VV1zTqzog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icAnuhh3TeyD+VEyNsAWyuflQUnsUKsA5BEasUvyFTGqWYOemtCJm2t2qyg8H0EUde3YyYeiTk/cQHrgFAkpH9MXSNxC4TEqTOwzpBG8iLsni9bDUv0FciXFBVA5sMKtAfWFU0LiuvjCfFKQHmDqhUhN4VA1Ho3GUNb3JqOE958=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gaBKK8zF; arc=none smtp.client-ip=209.85.128.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-6e39bf12830so3970037b3.1
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 23:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1729750427; x=1730355227; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dm/MIEPBZZEOTofpGdxuDln2Sbwtj9Q1T0/qRWDHTc0=;
        b=gaBKK8zFYRXDzScGu8qlyEb2q6qPicPUyzAmDe51xBuDbQ8enAl7/xeVo/P2VCqh4L
         YjXBMvEzier6cND2M5RVzIBArxV65DPMgLUGIcWIweTNElwGrmV+cgWiPZ0Zx1StAmpf
         x7uo6skYH6ffLib06bOVKnlr5LjLJeeG8TAMbk1JhFcIj5u/jD1cGE4pXqTnfiZhTHex
         WO3GL01bSurFeA7OA/URXbP1/8wiQNaLHkRIlRihPjhcyfSLlZSsASV5bQk9ht71NZ6o
         NROmO1iBVo2l2n9cTIsJbUczq6lUXNewv9t8BMC75fMhD7jgRnLNuSbR//+HE0fUuGOx
         GAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729750427; x=1730355227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dm/MIEPBZZEOTofpGdxuDln2Sbwtj9Q1T0/qRWDHTc0=;
        b=ZuqG4KGkERxznKFcd1EDp02G1z8k1KQHRowI7WS+GiQLPA2sOxl5ngzO1g3mxi/5fI
         W6gegQqlpNotGnD2/aRN8Con9PHL7eIA6Q6IDqCi2mzzMc4PfPQw5A7uECH5xmj0h2yM
         ju+djELJ0WML8MGhr16ZOexGoN7qciT4iKyfnzgs5qeyIThauZ9AyGwlYlhbTk2I/Gdx
         EIn6fB/pQVHONMq1KQqOZkEL45cdho7hqaG3BkQ3c4eKVykKwJogQ54FVGxwbRh5vWy0
         oWg6N4C0GuCd0uu00LNpY5nTrIQfxLyYo9JzDaX8u7XE6i7sY37iOqYwVJs0lCjxqKug
         IiEg==
X-Forwarded-Encrypted: i=1; AJvYcCVuFzVlXf8w5wrGCw1ubijjigc5r7kzUJvcjzFMZayLUCB99zRPaBbqsxgJFr4nD36+09fG+b2USA==@vger.kernel.org
X-Gm-Message-State: AOJu0YytgLglauY6ZvSkPezA1J1keXELyUqpN6RJVASVNSGT4BjPcJ9l
	zteqf8HjSWDE7rMfrCaB+CKBX+noZDzy7aW3o536VOVUZfPZBql/pZ0OuZxpY/3YOzuKVKVRaFs
	sTdQmUKNd2zRQhRFwnt9b9snl61ZWddLo
X-Google-Smtp-Source: AGHT+IEhyEKaFLcwxKzb9qz5fWduhegmFNqG9YQNEHkxE03Rz8LClOBW2B9+P/2B9IZUzvBsvOtnFWept6qx
X-Received: by 2002:a05:690c:2c8c:b0:6e5:2adf:d584 with SMTP id 00721157ae682-6e84df79fc6mr5430387b3.14.1729750426835;
        Wed, 23 Oct 2024 23:13:46 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-6e5f5a81ab3sm3805517b3.39.2024.10.23.23.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 23:13:46 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 069DE34040D;
	Thu, 24 Oct 2024 00:13:45 -0600 (MDT)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id E3D57E40391; Thu, 24 Oct 2024 00:13:44 -0600 (MDT)
Date: Thu, 24 Oct 2024 00:13:44 -0600
From: Uday Shankar <ushankar@purestorage.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V7 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZxnlmNGYWz+AikvV@dev-ushankar.dev.purestorage.com>
References: <20241012085330.2540955-1-ming.lei@redhat.com>
 <20241012085330.2540955-6-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012085330.2540955-6-ming.lei@redhat.com>

On Sat, Oct 12, 2024 at 04:53:25PM +0800, Ming Lei wrote:
> +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> +		unsigned int len, int dir, struct iov_iter *iter)
> +{
> +	struct io_kiocb *lead = req->grp_link;

This works since grp_link and grp_leader are in a union together, but
this should really be req->grp_leader, right?


