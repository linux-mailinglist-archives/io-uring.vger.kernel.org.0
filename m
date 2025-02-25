Return-Path: <io-uring+bounces-6730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160FDA437ED
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E2C3AEA3A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E782D25C6EA;
	Tue, 25 Feb 2025 08:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ReGmh2+F"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CDC25A2CF
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473065; cv=none; b=Lbz828iMy1L7dXgpWlCEhDPgypZ9XFCe6bWzzlen58VueyRxgdfJen3J7SEUOOblst+cWMph+UkA2Z9wMYa/cOMeUREi2Jz8j0/Fzmm0SshvGWB8oNSyhooDa3Yd8QdMsi8Lq8+ciAzBVcL2+9yJsYBnFFNYI/svFKDTt0N3E5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473065; c=relaxed/simple;
	bh=uuv8ZgmpOlmJQpAdciLRDo0G8IC0mjavFEn1bxYGn4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jc/NhD7EvB3Ke8hv//42hD2sc3WdT3a4SOHLkn2ffhem8dxi/zMEyuMh/dTK1mLxvIdthSapOTKLLHrFFBHp1JWg6lFk17lfNbiCI9VhndzwZ5gIGjiZYgn/ljfYrgfybIaFq1cxnGoh3h5d9RMyJ8X3L8uLUqSGqzRRZc5aMeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ReGmh2+F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740473063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVVrby4aLD7jcZhFshhdC7T4zMS/FfecuM4BztbogwU=;
	b=ReGmh2+Ffq466WcQ4luCHdZMMJrq8bjb3O+EBYMTmZ+vr4/6+tl+HpOC6zCyP/TM21gnRO
	1WflkLJgA/d3jR/Cbe4jm2B9ffjRTJOiE8eBBDT7pYrUaxZlaLJfE45pwxxObk7JM4S/7c
	A+sMWWZ05EP8G5BDvr98W0n4I0Kr6sg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-ARuI5unZPv62rmLjRDnCyw-1; Tue,
 25 Feb 2025 03:44:19 -0500
X-MC-Unique: ARuI5unZPv62rmLjRDnCyw-1
X-Mimecast-MFC-AGG-ID: ARuI5unZPv62rmLjRDnCyw_1740473057
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8702F1801A16;
	Tue, 25 Feb 2025 08:44:17 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D385F1800965;
	Tue, 25 Feb 2025 08:44:11 +0000 (UTC)
Date: Tue, 25 Feb 2025 16:44:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 03/11] io_uring/net: reuse req->buf_index for sendzc
Message-ID: <Z72C1uhv4uDKnIZE@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-4-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Feb 24, 2025 at 01:31:08PM -0800, Keith Busch wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There is already a field in io_kiocb that can store a registered buffer
> index, use that instead of stashing the value into struct io_sr_msg.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


