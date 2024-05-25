Return-Path: <io-uring+bounces-1965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5271A8CF007
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 18:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E87EA1F2187A
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 16:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D3185628;
	Sat, 25 May 2024 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IVaCrYK/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29784FB3
	for <io-uring@vger.kernel.org>; Sat, 25 May 2024 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716653391; cv=none; b=kJ2r80r4VA0dgDIXpACCzg0V5+x8d6CMulUJCW9QhCWVtVG93OJYnyzGvs7fTD+jVQcbcMCZueSXytlhhsINand8l5jhcZDbMfrjp4DsJdeUs0uVDwuQasoMs59tIF8asYcPOXKwiI5ZDdJHB6KeZeyFlvJI0C3L9wuvdcOiVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716653391; c=relaxed/simple;
	bh=VM5I2uTUmX4OhY8UfRSsCI9d2jg/j277eCpHRGuVf2E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mKMdfsxlRwy95z3vJGTCnmAU2ySrvJgG6MTaJZcIOjV8nvo7Q4uakUXQ/RU4yOospD64fs7Xdzto+P2TcJmAt05L+0BHblNvAjF0GEaaWoj7G5/DcZbWdTIk/07gXOqhDiopiVIhWkmlxReefHnffnobAtyKoroHvgnBkWXh4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IVaCrYK/; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2bfae86f1ffso9988a91.0
        for <io-uring@vger.kernel.org>; Sat, 25 May 2024 09:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716653389; x=1717258189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TyOoqYg2VosbVxxzixRdDuTDxf/k2CkTft7BE9HLOg=;
        b=IVaCrYK/fs5FdXtRIdnvLtqkBY+fxGX3CMRprwRAfS7iYjTORe7Mt40NAdR/KaRtXv
         G7VtykmRv8NozWpxYu36p2anmIrQJJUj7RILVA7LD/RzYID3lFok0Gnz5fOqvSGsqx41
         qSjKjt1/IQ8bkX0EqEdaF/n6SOCqmtSzDwBLC6a2xz650Lw3DhHTy8sYn46t+htfJ7T/
         qfsTiDom0VbrGsAl1245cyQEEpa+TqCFwlJt8Ex5q8E3shReg/cz5T0da5yGmA7Tk3PP
         q4xglLFsZbABhjwml0tlMyzEPERZ6RdjQ0JZwTqgXDVrQoHIos8MuQlSEZ+DCNG7iqlA
         CcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716653389; x=1717258189;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9TyOoqYg2VosbVxxzixRdDuTDxf/k2CkTft7BE9HLOg=;
        b=ATfX2QgWfQBsfM4Zk9lfsq4Ma8aPD0eD9oIzhL10TW1FwRxDNwjnuYJCKZFMX7LYpu
         SgPlgRn2UBYPV24FwD4THgsLZq27InDS7UMMRcFLvZd4ThWiN8T2OGV1Wwk4BdVWgXR+
         IC1HC8kPDu7FrecQgFwcN2sBTqPRP0874nfYz3mg1CxRIJo6zFOoSQyRILOUdJCjsX6d
         IWEeN5DLQQZv0ja8MRyuoyacSI9CXQpmgHs57bgPTEdrfRiVgCAR64PN23Hsqg/S1+y7
         WuBv46ZEGU/boiF5D70c9uq9lL2RH2wIqgz0g0EdfH3bykLad7eltcXa/KLMFYCsBrQk
         /MXw==
X-Gm-Message-State: AOJu0Yy2Wfh4SOERrMS6Kp0Ajna0oGj1GyjeP3tzSX5LM+rtb8qSHTVI
	w1h6ue2bj/jMMhIHlLYYMi5BHN5hksrNN1eVkcaAcOvHyTEzk3MB+uUsNUkrNBGzEK0SdClfr7y
	J
X-Google-Smtp-Source: AGHT+IEiVkaqjqd67MgiNt4xOhJeYhsU/qBOBwYcZN0ml8UgWcpJpOLnBXEr/uxgHiUHIt76iqKwwg==
X-Received: by 2002:a17:902:ea0a:b0:1f2:f9b9:8796 with SMTP id d9443c01a7336-1f4486ea170mr56528025ad.2.1716653389352;
        Sat, 25 May 2024 09:09:49 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c96ccfasm31974765ad.147.2024.05.25.09.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 09:09:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240523214535.31890-1-krisman@suse.de>
References: <20240523214535.31890-1-krisman@suse.de>
Subject: Re: [PATCH] io_uring/rsrc: Drop io_copy_iov in favor of iovec API
Message-Id: <171665338621.160479.12908327797304327838.b4-ty@kernel.dk>
Date: Sat, 25 May 2024 10:09:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 23 May 2024 17:45:35 -0400, Gabriel Krisman Bertazi wrote:
> Instead of open coding an io_uring function to copy iovs from userspace,
> rely on the existing iovec_from_user function.  While there, avoid
> repeatedly zeroing the iov in the !arg case for io_sqe_buffer_register.
> 
> tested with liburing testsuite.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: Drop io_copy_iov in favor of iovec API
      commit: 96b170eb1ebe2be0bb2e55e825b876e18bb70293

Best regards,
-- 
Jens Axboe




