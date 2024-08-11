Return-Path: <io-uring+bounces-2696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB52A94E3B4
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 00:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8037281119
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 22:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA0015C127;
	Sun, 11 Aug 2024 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="H2YF5rrm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3818E06
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723415843; cv=none; b=tQWdPyvfMyHAKQ5NKzfdufuUFWMhcQxS1yi/FoB+wkJ5QO6JCk+iB5pfmX2r189zdGccHZ90+DzXax/AThBFIjZKwTQGObRI4mRiACIc2k98Z8jEBtqXyvyOqj07lTuETm/j655fenTgr70Wm3M4USDcsJ1QjtPNZXb8nGbOPAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723415843; c=relaxed/simple;
	bh=VNedpA4qJyxdOa/OoIKqQQ1QCHz+IPqidyYDOR5Lur0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fNdr7rOmk90AkgzhBkArA2VU8yhI9tx4/TFEfLuFASbKVWrP15pK/ZF/nN4h0oAzOhSs47uJeLNVxtojVZskxRgHgIxh25tuIO43N1kgZEkvJaJCTviWNV8bLHbFpfmnqJK33JrLgDLnRAR3n/ugV0A4uujzUJNL6JWCqtdCxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=H2YF5rrm; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7a843bef98so368474166b.2
        for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 15:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1723415840; x=1724020640; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fi3DHiW7tdtkLQ371tUkhEhPUFfPzDV98R5yjeFOGsg=;
        b=H2YF5rrmjtirUXaNQTjrcvp+GjhIdfVQ9s78uAd5N+OwMgfYQ+D3xOselDYamm+GFU
         6A41RY6puJqGhg0zYvwFrVzv4XmcgHfRo/VQYcvthS0h8i2FcnIUN/wFZinKGrW7pXTa
         nx61uyqo7tvcm+d7gWiifEsWI+3BbUWyLNk4Qg/QRFQ3BySg8GdhAl0PSSDFDjzSZlmR
         2YO9YN8u2jgsTYk9XymBWwEDTTYGAGt0f5u1jqd4cTO9TzSocwqnIJIjILf45pi4e5t5
         qAQm/qDJqdQtcX3rtQwMbubWmcfHjMEmc89sP/LBV1R0FzK0JCiG2Ro7i5/rRhKcf8lr
         D58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723415840; x=1724020640;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fi3DHiW7tdtkLQ371tUkhEhPUFfPzDV98R5yjeFOGsg=;
        b=W1AAf9/Re5I4Dymxawg6bcQVNwR8S+2F8vu7bScS+bMLc6eos4safI2Ke8lLDo+H+A
         afrXIjeHNh3FXYRT+l173/kHNSrfJJbpgJ7mUy4OjuIVQYfCPvnTNU4L4fym2RcWWTjs
         Z5R9QVAogzUi+fR0PfuYp9G0aalDQLtiCXBxHcFtAgdAqZInsRGs1C9+1EKlUDaEt11K
         r637/S88ZAmMzBGambBGLkzwEnO+M91WfSvw2mzgMjcvey4QiJHKfJbT2PJyg8xeGcXP
         NbvPFfPHT3ShGus423ijtfs77EHnyJUybQdyehgRJsZXNeTZxAmG1Hk8kj4D82rgIwTs
         n5FA==
X-Forwarded-Encrypted: i=1; AJvYcCV5aw/RTvNotpdnDks3aLdCNCqZFcPgzQr2Nfc/cX1rWiXI6wjEftd3ZhhS90n9bbWLOVFb89r4fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1IkzVz0F+Zf5pkdY28LLczBZaPAb2VLYTNqcd4eVnmQUJhVUv
	Mx7UP2OESPzwz/mP6zvFq4I7SU9D1XpfMcrz+Fsxih3UY76v8lcopEI82r4MOi4=
X-Google-Smtp-Source: AGHT+IEq9adQCPBN7DOtu1DPOBaYf9dbn+FDu75Q2/UoCbCIcoeuLyh5lb0NYVemT8mR4c4sd1/wMg==
X-Received: by 2002:a17:907:972a:b0:a72:8296:ca1f with SMTP id a640c23a62f3a-a80aa654af1mr622357066b.50.1723415839916;
        Sun, 11 Aug 2024 15:37:19 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:a92:ee01:95ad:df39:6ff7:9997])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80bb0e1355sm177268166b.74.2024.08.11.15.37.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2024 15:37:19 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH] io_uring/net: Remove unneeded if check in
 io_net_vec_assign()
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <1207e17b-7a32-42b1-8047-b01e221ab3a9@kernel.dk>
Date: Mon, 12 Aug 2024 00:37:08 +0200
Cc: asml.silence@gmail.com,
 io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <57E4D3C3-5960-4F71-9391-C480E9FD310F@toblux.com>
References: <20240811222638.24464-2-thorsten.blum@toblux.com>
 <1207e17b-7a32-42b1-8047-b01e221ab3a9@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3774.600.62)

On 12. Aug 2024, at 00:31, Jens Axboe <axboe@kernel.dk> wrote:
> On 8/11/24 4:26 PM, Thorsten Blum wrote:
>> kfree() already checks if its argument is NULL. Remove the unneeded if
>> check and fix the following Coccinelle/coccicheck warning reported by
>> ifnullfree.cocci:
>> 
>>  WARNING: NULL check before some freeing functions is not needed
> 
> Yes it's not needed, but the NULL check is done after a function call.
> For the hot path, it's FASTER to check if it's NULL or not.
> 
> I can put a comment on these, but honestly I wish the ifnullfree
> thing would just go away as it's hardly useful for anything. It's
> not like it's a bug to check for NULL first, or that it would find
> something useful.

Ok, thanks for explaining.

