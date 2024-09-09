Return-Path: <io-uring+bounces-3095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08925971D96
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 17:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9A91284647
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 15:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8E11BC49;
	Mon,  9 Sep 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uqGfKSCZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CA11C69D
	for <io-uring@vger.kernel.org>; Mon,  9 Sep 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725894578; cv=none; b=giRWmQfKjaRGvjuBx1Zg6JfA3FAJ2oDunH7D4tZj1LoRTk9toeyYYRkoJkCrZYpIzwgqepCujVmM1F9zvOD++vmTa59pqXAI/nXKL1mnjiYOvYadOo2PkFkhRkzNSD1oI+wIn85uj+P9DVXNcAFNSxlW2RaG5d4pmpNOtFamqg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725894578; c=relaxed/simple;
	bh=KrCuM112xvksWAEhVjhwKSWtIGAgg/emdYOf6L8k8tQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XqA5vECvKWsykomjW4d/0LlHJjFgGL/fC7cSrAED8Wf79eAu2dYF7WAjklV//OtCFQsI6wm/X6oEYE1XA/tD77DoyY9ymnLWeb6YDSllWfIgvpkJPm/0AVd+4eRjHcC/m5fAc6fDU/OsymXS2DDpovS9ZRr6FQcYZEfupNPVDZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uqGfKSCZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-718e482930bso1233276b3a.2
        for <io-uring@vger.kernel.org>; Mon, 09 Sep 2024 08:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725894575; x=1726499375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZD0LM8B0SLCDFsrFpilRozE4KulMUqwHZ2jEOs5nf0=;
        b=uqGfKSCZ78R4uf+geLebFEy+dsojQ834HrsPv/tpr4A7Z50QZHPT+yUjJQl/piJCJs
         eFb90DpIPF/PTL+AFjlJc1nLEG/ELbWdxU/griJT9KjApJoQvEVlgey9dIvxVjUa6QrL
         SRdbK/A3lNsbCIiwa5V0P9kwPiINlf5rg+pxfBBDsrSSdb1peU8fxFmTe+WCqj36/ptZ
         2+ykBCW/t42/yB7ZPc1NPBh1tAkVf9kBYRlzi+pE8825EJndDzy4YF5PnyQljRzBNoVJ
         xz3p3ao5HmsS2qaCPDYmK0ZFraeUb7wp+Ipimt6gMIjjIFTxqveN/IYEljlMxbkE7VHo
         K+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725894575; x=1726499375;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZD0LM8B0SLCDFsrFpilRozE4KulMUqwHZ2jEOs5nf0=;
        b=byxS6loRaNDEbXImELBxG6GMbxoQq6x/TQjUl/4LONU+z7WH1wewR2rLZNY+AGnSeM
         xjNFZ/CWUmn/KdCV9pYMqDxgIRhYF3nEy5yQq1P/QY+s7JCd2r6HOQCyfVIb+aXsuShX
         beYnvsF4G/CkVmi6Gg08VbxONCRJW3fadjvUbxY9433KB8IZbYx8NUpW6QpxxO3t8XSQ
         /1ExmZy4f2FDScP8X8ysc6csgbd7c+RsjhU/yHuAMSKy9lL+TiAnVfCspTA0chBD45f/
         CRNZeuXNtTfBg7My6ddWyTAGM3JiEidasvnx+CCcxww2Waw0Se2LSqDdEx1vF7HqpzDf
         XD/w==
X-Gm-Message-State: AOJu0YyUFGj3QMQ1iwTY0eIfitDWe3FDlcKf5MkWnaiw1IbYifZ8cZqI
	+b7PY9gC7r1mhSZMrurhhBUGes9HIcMLbY02uaa3y5OZ1GzmVeMA7Yd4dFW08UE=
X-Google-Smtp-Source: AGHT+IGMnrlvMfMiebqng8NbwSxr6iDv+FCr1bhfnL2Hi0eMUOZmYfxKU7s51gi//tAzm2Ppg6U7sA==
X-Received: by 2002:a05:6a00:845:b0:710:9d5e:555c with SMTP id d2e1a72fcca58-718d5f141f4mr18435523b3a.23.1725894575372;
        Mon, 09 Sep 2024 08:09:35 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718e5990bfdsm3618706b3a.212.2024.09.09.08.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 08:09:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
Subject: Re: [PATCH v4 0/8] implement async block discards and other ops
 via io_uring
Message-Id: <172589457427.297553.5122724634440899238.b4-ty@kernel.dk>
Date: Mon, 09 Sep 2024 09:09:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 06 Sep 2024 23:57:17 +0100, Pavel Begunkov wrote:
> There is an interest in having asynchronous block operations like
> discard and write zeroes. The series implements that as io_uring commands,
> which is an io_uring request type allowing to implement custom file
> specific operations.
> 
> First 4 are preparation patches. Patch 5 introduces the main chunk of
> cmd infrastructure and discard commands. Patches 6-8 implement
> write zeroes variants.
> 
> [...]

Applied, thanks!

[1/8] io_uring/cmd: expose iowq to cmds
      commit: c6472f5f9a0806b0598ba513344b5a30cfa53b97
[2/8] io_uring/cmd: give inline space in request to cmds
      commit: 1a7628d034f8328813163d07ce112e1198289aeb
[3/8] filemap: introduce filemap_invalidate_pages
      commit: 1f027ae3136dfb4bfe40d83f3e0f5019e63db883
[4/8] block: introduce blk_validate_byte_range()
      commit: da22f537db72c2520c48445840b7e371c58762a7
[5/8] block: implement async discard as io_uring cmd
      commit: 0d266c981982f0f54165f05dbcdf449bb87f5184
[6/8] block: implement async write zeroes command
      commit: b56d5132a78db21ca3b386056af38802aea0a274
[7/8] block: add nowait flag for __blkdev_issue_zero_pages
      commit: 4f8e422a0744f1294c784109cfbedafd97263c2f
[8/8] block: implement async write zero pages command
      commit: 4811c90cbf179b4c58fdbad54c5b05efc0d59159

Best regards,
-- 
Jens Axboe




