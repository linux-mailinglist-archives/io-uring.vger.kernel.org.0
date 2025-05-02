Return-Path: <io-uring+bounces-7814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63895AA75F0
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 17:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD7D14A50D6
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 15:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8805325A638;
	Fri,  2 May 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BhD3f6Fv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E654125A2C1
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746199536; cv=none; b=liL3ZTTXsb4wj77SpvzuVuCy5eNJSynFbFLoA3TuHI/6LLaHnaRrxa1XWheJdzd/yz+AO4vglizmjCwt7KYcge3SJtKJjNz5jxDtXpkf70A81XDKrCZ+yNThMt/rQvQKPhkCTXTcjRU3FRtbhs/eUZHpiUez2SR4Nh+duVn2jM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746199536; c=relaxed/simple;
	bh=4vHb/e0Kpp9FikZJirZ0eO3cVqqiZE9ibnExEMgiK+I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hRSVUomkxw23D8o/5lMM6lNobDkO+yleSZwCd0jedBwnEvftZToFWQUQ+EPkxtQGH+99KfP2DaJaj4XHS6MjJ2zX+Sm+4zLt/F4EUJq0NC1aAal+xPzcqOs66Uey98VC9vY/S505IZ8l92MK8KjACgoiIDdbNuk53FML9pKbX2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BhD3f6Fv; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-86192b64d0bso212163339f.3
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746199534; x=1746804334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swe/trEBPnb/cRsPYQHbOe82io1cAUpgTTADUGLC8hA=;
        b=BhD3f6FvUFJ3KwquWL40SHIbEOlHR7pCxqQg13q/jTJpAOz5HHuVywqzyHhfeXclGT
         kLQ/n61+La1t/nLzLXsfb+HN60NpSfaPyITkdbmN0Gxxv2s4r79lVpwlU51Ng7aE/Nen
         LACX504q419CRtJKzBV3dOOi7siiu/nibQrmbToJICiUpWUdX4KHla3sPiAWmW6bFhkv
         a7Z8SqE4p8+JgnqoPsywSRdbhgLqWNYCo7ysxH/AOvWeAnrooSkX6Yd0/4Er9TXrzcSv
         wq/b9hrZ4lUQTtaX0kl9oN+rZM7+t9xscQgnzwGNYcGP1wFKxpOKIjhOFy7u/bM5bWNO
         tVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746199534; x=1746804334;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=swe/trEBPnb/cRsPYQHbOe82io1cAUpgTTADUGLC8hA=;
        b=g//Qh0C12+8CdIKxGgfkb8+FbqpiF0DwN4YfRhzDk/HhaNhdh7dkTR9iQVzolUxXBN
         dWIv3ldl85Y/mUGUzPfLmODfrv19IBzn8xULbI1hsb+jlkGPeJwEi509JBh3ty7OZE7D
         7SE5VhZYbn3VDJqeKb+jw3LFtiLDl/kRDbuVAQF4ZaRVRlM1krus1RhMUlML3TvA7+S7
         6lA3k/FgqbBXLs3bvAqwTopNgwNgtuDZ40EmGKOduXfvSDG+tbhO4FxbGxeF3GsbC8Us
         nBtHojOUXmj0yIylr5sMLIxHn17RZlGWFH9HIZi8iu7FykqTGOt4b9fYLtrb2ZMF6rBl
         nSrQ==
X-Gm-Message-State: AOJu0Ywt+4DZw2pSTkp+o4MEYE7S+BVlogVjTuZNqXVi+7nNUevJsBSh
	QQUX+9zR5uVMz2n1qnMAhDjKFtOIfa55HOvCDAgpzYdM/oIEExZJCUSdRNm0niY=
X-Gm-Gg: ASbGncs9qls56FoXK2CIo5AAbBOqF1OedasmOyhSivhhpJwGt98huMFaBxo7AsyFqgc
	RiLVQAMKOsfB7lDOvwBRR5EYM8YHg/iTTY03aE/QAyQkckOZ0BNmpxlLbSOcZaPw2H4GfPDBucn
	vFwcRXW30Xcmwj5nFbUPNK3i/9RhiAfjygvlyhUc6nLvqFe27EySzITH9f9lJtnB/rrs/s2dJO2
	JsqFGLzeDMy6L/lHUJLlGkFwDhdEVqAvZKrw/FWzVVMolcIMZEzIskKqXJcxpT40+yhfOZYZsKo
	Zu2/Iufi/3oKGShymMJG8UpQNHktLBLqxOscHQ3r7g==
X-Google-Smtp-Source: AGHT+IHny6qzFoF4mOzb7RBx7VS6edPHk1SLaBvgePlKlF87WCO8sxdJxrc2DFrFA1MQ2Kk3f5ESWQ==
X-Received: by 2002:a05:6602:3687:b0:864:a3d0:ddef with SMTP id ca18e2360f4ac-866b343cd04mr445111439f.6.1746199534158;
        Fri, 02 May 2025 08:25:34 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa8e1f7sm429300173.121.2025.05.02.08.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 08:25:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, netdev@vger.kernel.org, 
 Jamal Hadi Salim <jhs@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
 Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring 0/5] Add dmabuf support for io_uring zcrx
Message-Id: <174619953298.748556.14620839074775551188.b4-ty@kernel.dk>
Date: Fri, 02 May 2025 09:25:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 01 May 2025 13:17:13 +0100, Pavel Begunkov wrote:
> Currently, io_uring zcrx uses regular user pages to populate the
> area for page pools, this series allows the user to pass a dmabuf
> instead.
> 
> Patches 1-4 are preparatory and do code shuffling. All dmabuf
> touching changes are in the last patch. A basic example can be
> found at:
> 
> [...]

Applied, thanks!

[1/5] io_uring/zcrx: improve area validation
      commit: d760d3f59f0d8d0df2895db30d36cf23106d6b05
[2/5] io_uring/zcrx: resolve netdev before area creation
      commit: 6c9589aa08471f8984cdb5e743d2a2c048dc2403
[3/5] io_uring/zcrx: split out memory holders from area
      commit: 782dfa329ac9d1b5ca7b6df56a7696bac58cb829
[4/5] io_uring/zcrx: split common area map/unmap parts
      commit: 8a62804248fff77749048a0f5511649b2569bba9
[5/5] io_uring/zcrx: dmabuf backed zerocopy receive
      commit: a42c735833315bbe7a54243ef5453b9a7fa0c248

Best regards,
-- 
Jens Axboe




