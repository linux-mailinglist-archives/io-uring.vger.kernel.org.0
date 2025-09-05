Return-Path: <io-uring+bounces-9592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A28B45605
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 13:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4BD5C5FA7
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D06345730;
	Fri,  5 Sep 2025 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oTQxL3O+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC2D343D93
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 11:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757070846; cv=none; b=VIOY0MpABHDZbY1ob61qxWVUFLPl0pi3IfwgDdEmBQaOlYub6KDF9oskEpZVq7/aTbhQAZ0VWh5g2ojFdaEcbRT9wLW61+dYQjO+v59WiHWW3EhyUe+3VzDxDqlhj8p0nW+tR5MHsN4JYDrSt5J1Cg0FJj1+KLrPQnyEVlv4btI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757070846; c=relaxed/simple;
	bh=A6YZY+2lgCDRWE7jZhtd0wPHGCzmsRLPirzvJ650XSA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MV1cXRehKHSv80frY2PDvJfcjAroX5xqIAG6B+P4ICkN3hdIQ7hi/jbpsrpumI7rhqF9iGtgtDbXsZ4esPxYn/g9TrVcF8soMWJnLdPAJehDQzuC46/0E28GCqPxkBPES+wbsAEPUatbPEWAt+oUwey+P6uugXaPJ6dkO4M8j48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oTQxL3O+; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e96fbf400c0so2391335276.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 04:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757070843; x=1757675643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smIFcZT6fRwTwOdoLCuotEOilxdiZ96AHCt5ydM2TdI=;
        b=oTQxL3O+flcMzzH3qTc3DJJ676coZBx8GslfzSoL4kUeg2gHPqkSBjb/+PRhRABHTV
         cfl5QGTEaCy3lST2Op+RDJ+qjZnWpFF3vC7vTGjUmyxQt85QH+N7P+bu2yaAUvSwSfLv
         2k5cuMaYguWsNsfFoApHupr6QNs4elRzhA7O6jQII4/AoLbVGFOBLpfKpeDeCsz0gm5C
         w30L/yPMqwDFXGv9aAUSqLM/LO7EkQvhALIO+crNIJ1cYSi7PI6O86lRpnx83lb6h4vS
         8WfLvHewTGEIQHoh31bJn7gGNFvLxy/ww0/Op3q4+9Xo1Jn9vI9EJP86AjSZKC8zaQty
         o7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757070843; x=1757675643;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smIFcZT6fRwTwOdoLCuotEOilxdiZ96AHCt5ydM2TdI=;
        b=Fd4NV8IBG8sc4dGBo4xxwRbDP5lJcIPgihj7lWfxYtVs+jDl/aCTcoDMEjdWDCM72C
         1gPLi/DbTzjSlZrQTIVC9jzK7vK1V8G7y4gw1VwYm8RoJAm6o8r+w703JNbIPcuB49/z
         wJvNOj7GcqOj0tbi6BOZt68ojiDlQZCkJWb2ZrmTcXCtl6006eqzW/vgTdzLoSU8n8sF
         yDuxxqPoCKZPkE4R/bVfUUm2hlCR8I9NraAACCBsF7lTjRXFQbJ09zklrBg/MPOuOau1
         bM7oUC5NGJ65kY5aF3oSebQc6IS7k0xWrOZpRZ4v70RhyaVsdsMF1Mv/UjI4BxIIpxiz
         qEfQ==
X-Gm-Message-State: AOJu0Yy9ys4e4ocm5CJDXSwNrBQYC2vxRJO4uWTQlFD1OnLPoBJjY039
	FAeNmpRU41On7uN+in8NNE3ORm92giQwdPoFwprB4zM9F3+clGwRnb981mdaeF2vIKoKBJUjAYX
	TM1h6
X-Gm-Gg: ASbGncs3A5w+2NykwUEanHTnaQ0I6KQ28O9HO5xDogCjEVAf8fYSvF4Z/S+HWed5miv
	Fe1snwSBx66axsxkIGt5sTfkHz84gtXpznDXDLm9Hyxi1c84Wfc4udf8PFSXFaUvaG5xKwV3+O8
	vNkO7ePGk8SYZI/xog74ZnBZ1N1DmaEY2V45R4lCD2HE8Lil4DFahMQ0xdoIpJn9UHL9s78AZ5Y
	uJXkFnguMQgo/ECCoo9MMWlqdMoVNC+zeObsogWwNUidlSZCij7T8fUK5SQjqkZXJ/gCIZNh9Me
	xS29v/pfeRR07bAXxB50tSfSlkT8Fql9vvXMeC+jMW9nn8Bvs1aKvfTkx2kidVKF4DFvf4fQT/e
	MukyvkyyMZQ5Ysj2KZg==
X-Google-Smtp-Source: AGHT+IH+J3QMzNBHejPE3u8sZJfVn0k75y2u6I63HrlNeAIS2gwpm3hKHIkQcZo1cU57jjmcfNQLEw==
X-Received: by 2002:a25:6407:0:b0:e95:3010:1124 with SMTP id 3f1490d57ef6-e9db04d274amr2050532276.18.1757070843085;
        Fri, 05 Sep 2025 04:14:03 -0700 (PDT)
Received: from [127.0.0.1] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbdf57266sm2999999276.14.2025.09.05.04.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 04:14:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250905012535.2806919-1-csander@purestorage.com>
References: <20250905012535.2806919-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: initialize io_rsrc_data nodes array
Message-Id: <175707084146.356946.8866336484834458029.b4-ty@kernel.dk>
Date: Fri, 05 Sep 2025 05:14:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 04 Sep 2025 19:25:34 -0600, Caleb Sander Mateos wrote:
> io_rsrc_data_alloc() allocates an array of io_rsrc_node pointers and
> assigns it to io_rsrc_data's nodes field along with the size in the nr
> field. However, it doesn't initialize the io_rsrc_node pointers in the
> array. If an error in io_sqe_buffers_register(), io_alloc_file_tables(),
> io_sqe_files_register(), or io_clone_buffers() causes them to exit
> before all the io_rsrc_node pointers in the array have been assigned,
> io_rsrc_data_free() will read the uninitialized elements, triggering
> undefined behavior.
> Additionally, if dst_off exceeds the current size of the destination
> buffer table in io_clone_buffers(), the io_rsrc_node pointers in between
> won't be initialized. Any access to those registered buffer indices will
> result in undefined behavior.
> Allocate the array with kvcalloc() instead of kvmalloc_array() to ensure
> the io_rsrc_node pointers are initialized to NULL (indicating no
> registered buffer/file node).
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: initialize io_rsrc_data nodes array
      commit: 0f51a5c0a89921deca72e42583683e44ff742d06

Best regards,
-- 
Jens Axboe




