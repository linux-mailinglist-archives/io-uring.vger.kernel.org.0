Return-Path: <io-uring+bounces-9895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BA6BBCCFF
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 00:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 812A73AE429
	for <lists+io-uring@lfdr.de>; Sun,  5 Oct 2025 22:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D381B35962;
	Sun,  5 Oct 2025 22:10:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4917526ACB
	for <io-uring@vger.kernel.org>; Sun,  5 Oct 2025 22:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759702249; cv=none; b=HK2mc/OauhXBJD/Jl6vy3ERFmFvw5b3XzZVmV7A0Udu/x2ot/UbMt+DzI7hf2/5LUf70rECgOnbszNh+OkgLVe2YIB9GsRRAdkEgjimERqgI1jMJXLxbY2Hdql6CZq464naEpYj5tLf1aiIUtSGClJ4Dwd2mujSRQP3W22+gnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759702249; c=relaxed/simple;
	bh=J8kFV7CJ0qMWzYyo4KyctyC2CCrfPz21lZs+Xuqj5dk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsA7uiAF739KRHphrYt0fUZD4LDxa+evmHs/AFOPqNZJMk1NWtF5cILSu6MVH4hcHTUc+knrmJhlEC5TVagcT4arGF5TMkKvRZdYePJMBQg/aldqOyznq3qnCfucgh/smD2nKBJ1qfKjwWc2wzGJIRhsCaUZcIpB/m6MVbM5W2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 09B29140681; Sun,  5 Oct 2025 18:10:46 -0400 (EDT)
Date: Sun, 5 Oct 2025 18:10:45 -0400
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: CQE repeats the first item?
Message-ID: <20251005221045.GA838@vultr155>
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)

I made two typos in my last email. The cq *tail* was 10, and I meant to say the cq tail* isn't zero which means I have results?
I'm planning to reread the man pages but I feel like that's trying to find a solution in a haystack


