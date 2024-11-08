Return-Path: <io-uring+bounces-4568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB419C2518
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65E85B22D12
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 18:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC79199385;
	Fri,  8 Nov 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zRuyM1VF"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5585233D96;
	Fri,  8 Nov 2024 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731091936; cv=none; b=pZDzWM3bo98Ns5nDO06vZMBnxzoI8OwTmXuLO2Ytn7lRaKxA4+cyFgSF1YYyy+AwonvuE4XhnAtXEDQAQ5fG3Xoa4ONvQRGg814wCOENAX2456D1+yFQWjdtthU9IjBlsebYZbclt5nfRwQShlFT8UmLfWqhlp7zLIGkYApWp24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731091936; c=relaxed/simple;
	bh=JVPYyABt4fIR2H2QHQjsQ9GDszOfP+4CM0lq2I2MeHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AD4HPFJm1Nv++xlMaWz5j6PorQHlWUs4RGLOlIAX7CGtIsGDnLggyHWUO17vZOpxdez8y7ruAU7WHGpC9Y2aj9aPRliL+5ZjRzO+Y2f+iDwZTxMlXM/NHwmlgIlfRhCdkA9hVaggCXh6Hfmr23ct+SW7tgikew4Wdr5KBTzxDdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zRuyM1VF; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XlSjM11PvzlgTWK;
	Fri,  8 Nov 2024 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731091923; x=1733683924; bh=JVPYyABt4fIR2H2QHQjsQ9GD
	szOfP+4CM0lq2I2MeHU=; b=zRuyM1VFZ0FXJma19dczCVvpm+qz/06pgLbBbB/k
	BBRfVJJ5Agbtpzut8QwnRXGN3z6YdIz8XRPWNWZsHx111VOsuFyBe4exmUfvqcbo
	tVpD2OvlLgLpYmo3rhy5MkHx3qlBJHrsWPKP8O7cJD8+fkdWKHNWXslRRHir0NOD
	YWgNGEt7jdelnDraiq3RRJrRHeW0jBLSyxAYZgw5HSlYUQUEEJ7pQ0f/h5++VDNV
	54In+/EwxNdPbFtHlXQdU5BjEfPPpIuiSy3bQ0aApmgTErrctjUye9y+Zcuy2geK
	7tS/qlfOG9kXuqXUzzO67Y3RACA0ZqZF/5tiC+BwmRGSJQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id votlEUy7cqa6; Fri,  8 Nov 2024 18:52:03 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XlSjD0CbmzlgTsK;
	Fri,  8 Nov 2024 18:51:59 +0000 (UTC)
Message-ID: <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
Date: Fri, 8 Nov 2024 10:51:57 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
 <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
 <Zy5CSgNJtgUgBH3H@casper.infradead.org>
 <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 9:43 AM, Javier Gonzalez wrote:
> If there is an interest, we can re-spin this again...

I'm interested. Work is ongoing in JEDEC on support for copy offloading
for UFS devices. This work involves standardizing which SCSI copy
offloading features should be supported and which features are not
required. Implementations are expected to be available soon.

Thanks,

Bart.

