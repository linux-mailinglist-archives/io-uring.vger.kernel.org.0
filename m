Return-Path: <io-uring+bounces-7250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B59A71CA8
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 18:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBB1D16A891
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 17:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD171F791E;
	Wed, 26 Mar 2025 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hPlUboZl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9831F8AE5
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008736; cv=none; b=M5OU4RVAEFhvoRLThbJ7XGFY+eTXQx9Y7y4kEFlNRdl48pj4TIG/KBFJJBiZ9QCeq10dniVpbh9ag1VC5mk//wTAJRWyfp0ISWVtVk/AuxA1AsicHvKs61QAh4S3FVQ1kkz9bLhyhEG1ZEgIc3DDPIO7qkXvXAo5ITX1Oc1DDNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008736; c=relaxed/simple;
	bh=Qq9xeVTsSXaWrZtIjspbgDu/IPbsHTxCkEBGsVWCAIE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Gn9Z0DArQSzI25nKB4HUkYGhZfABZPIuOHGPMc8o5i994885y6Tnn4qgyrEE+hZlrQQAvKc+fUYsvc511CjpK6p7+kYmgJeLxlTWgblmG8tLDtlNBp8HssDJzNQD5B9rxpR9Nu2VjOVMh3esalnyQvq6h9mZkUzOzd8Wa+Y1EAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hPlUboZl; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c56321b22cso7590685a.1
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 10:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743008734; x=1743613534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9As/VLL7jHovW+piH2w50VnhaugZ9QsJT0naURZU3s=;
        b=hPlUboZlxAvk1LP1CPBu9cna6hWQL0PLsoANt2igLSm7vOO6iBDPddOQCh5sBFheVw
         FPPmucjHTuGylH7hJKqGgvGHh3EXLwfnGd4u8kY9P3bQC1Vm9vhZp4pLPIqZS8UH+C7K
         qmysvawarO/QQVVBa+ObIdc5+ogKi60xEntJ7vcfpSbuCuPw3ynNKe5z2xsuPAR8bv+z
         6hveFnWKAACx6DaUtw6+EVEd1KQUZjrnclZPFP2g236PGqH+LgHEwcY+8BdY8E8Jaw10
         tOIp6Csqabtm5aBWt/bqap6YahiHQH2u19jUqUuD+cAZ3zlC5ZoQJrC/dkl47hk1yKF3
         miPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743008734; x=1743613534;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9As/VLL7jHovW+piH2w50VnhaugZ9QsJT0naURZU3s=;
        b=AfADSF1I/VMhe7GS16EBbmEIqdn0bXvdLwoFSs8eC3ek/r3GGfdqNwjsQvi2nE/lQY
         3+YGTwWjPOOGJURN+6rXswaXcQlSeEdmg9WukWR6WKjTmZIjZ1jHQo4lPjOwYLgdXXgy
         OtgNtEwH22hHpmolOBUmS1+5kjuO789IOUeDAYcQ7Abbix/LKLWz1U+HJ0ZOpSxXfRPP
         TVwp/qS6rqjbzU4WRibmyKc+C3p7pn7Z0UWU2Femy55WW98w7c4YEY66YXsNU7v3vP+s
         KYIEe9tD8KRDWOU+lCAq2VtwwkyVR3p18yGOSp4dMVaGCrmSpEiIuUe4+6YVj89ri74y
         z6Xg==
X-Gm-Message-State: AOJu0YyODukh4J+FsytrFJv2PTrzQgBIt4odMn5D07YPbb/3fU+sUHzZ
	o+EDpgUta7jZ9nCfgHfKVlnTBfXt90+Up1z/k/C0xkwrJ1kobsOKd9ZpVzHe8ik=
X-Gm-Gg: ASbGncvUDYUpetvhKOiNukSZCt0YwLJP+iS0AbOxgJIt+MblakKxJJwt0nyhz1ECWYP
	zDCf2GjQOhFnkz0n3lNXoWICImQLzsSUferQpcMiC8jb8nVRHdes2rcdYMdfZJTGlcHH+76lz4f
	rydP7+WvWee8t6SRKUWD3i1sNN0wDBOCjf4esh2vArwMAyRGqYNV81cNtVv2LtTRjJUl3ueDU7Z
	nlxk3RXOS0VMPyXM5JlOlDigyIiDxMh+l8ajyeX2JlQgbKSLhfA/7kuvdYs1kJ9+oN/yFzfjuXh
	A3x42eOjEhelnxyn6dYu8G9LwdD/I4QGBOQU
X-Google-Smtp-Source: AGHT+IFeLSGd4Zfnuo5L5NOGuK2qSDCrKThLu2mY3DoydhUk3XKALRXNLIwLS8tpDg+SjvhEf9vfJw==
X-Received: by 2002:a05:620a:2239:b0:7be:73f6:9e86 with SMTP id af79cd13be357-7c5e49344a2mr543314085a.20.1743008734233;
        Wed, 26 Mar 2025 10:05:34 -0700 (PDT)
Received: from [127.0.0.1] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b9355ac1sm787733885a.110.2025.03.26.10.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 10:05:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250325143943.1226467-1-csander@purestorage.com>
References: <20250325143943.1226467-1-csander@purestorage.com>
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
Message-Id: <174300873298.1283773.3716596596961630041.b4-ty@kernel.dk>
Date: Wed, 26 Mar 2025 11:05:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 25 Mar 2025 08:39:42 -0600, Caleb Sander Mateos wrote:
> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
> track whether io_send_zc() has already imported the buffer. This flag
> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
> 
> 

Applied, thanks!

[1/1] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
      commit: 73b6dacb1c6feae8ca4a6ff120848430aeb57fbd

Best regards,
-- 
Jens Axboe




