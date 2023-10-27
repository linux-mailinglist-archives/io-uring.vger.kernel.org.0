Return-Path: <io-uring+bounces-1-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB687DA3CF
	for <lists+io-uring@lfdr.de>; Sat, 28 Oct 2023 00:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0117FB21600
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 22:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F223FB00;
	Fri, 27 Oct 2023 22:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud4zKv8L"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0763038BAC;
	Fri, 27 Oct 2023 22:56:50 +0000 (UTC)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BA8E1;
	Fri, 27 Oct 2023 15:56:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2144C433C8;
	Fri, 27 Oct 2023 22:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698447408;
	bh=O3zoGBXVfb5WJW2MwxE5HShF9ljYkHcSyGRQbT2KEb8=;
	h=Date:From:To:Subject:From;
	b=Ud4zKv8LSo/nrQt/CvxDP4m3ZdOPMrp7tUsSESflhyo08sv10KMAHeGmErEDvX5Wv
	 X1u6ZpuVUVrc6Xzu0in75RDb1nGIibEKbzfpwR01csDb27MAkb+LeK4Jgt5q379YnJ
	 1hUFAH97aE4h7ltSnhuO/qZhxpYqsdOIXxgC3zd0=
Date: Fri, 27 Oct 2023 18:56:47 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: dccp@vger.kernel.org, dmaengine@vger.kernel.org, 
	ecryptfs@vger.kernel.org, fio@vger.kernel.org, fstests@vger.kernel.org, 
	initramfs@vger.kernel.org, io-uring@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	keyrings@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: This list is being migrated to the new vger infra (no action
 required)
Message-ID: <20231027-strange-debonair-basilisk-cecdab@meerkat>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello:

This list is being migrated to the new vger infrastructure. This should be a
fully transparent process and you don't need to change anything about how you
participate with the list or how you receive mail.

There will be a brief delay with archives on lore.kernel.org. I will follow up
once the archive migration has been completed.

Best regards,
Konstantin

