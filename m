Return-Path: <io-uring+bounces-1539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 726B38A4456
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 19:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE053281720
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 17:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133F0135407;
	Sun, 14 Apr 2024 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HX+aBMUu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FEC134CEF;
	Sun, 14 Apr 2024 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713114635; cv=none; b=K5evigO5/zhVwtnl/QzXNaSSMPmXePlC6axoa+xUiVtmPCB1ugsI59xKytj38K10rlbJUZvM1nJCidw8jM2UsfNlKSDj2QIEJLr3h+NgHR83JnDJmp7oWc6H8KuAW+2b+g6PpwFH7Me/akyfl32EgSSm3PmsBzLW2JaytM4zV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713114635; c=relaxed/simple;
	bh=xC+CgHu0hZp95mkShXk7bVJiJYmZXJz30ed00tC9XpU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=DkzmznGxqM2Sg9E+epT1LC/6jRiVo8UUD/A9m4DuiD0ODXXI1W8++hWRRZvVzGlmxwAYpMPFrQ/dtZ5FBpp8bUuJzfNoXK+05g+oXrEUQImFPNwSWCeC13yaLAQHCcVwbG/DOOgqC1sYJWrgxCscxYuk9JANJilZ6Ctwb42DbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HX+aBMUu; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5aa4204bacdso2080864eaf.2;
        Sun, 14 Apr 2024 10:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713114633; x=1713719433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xC+CgHu0hZp95mkShXk7bVJiJYmZXJz30ed00tC9XpU=;
        b=HX+aBMUu4DFWvHpaez3Su8qKuaT78ACqW3dHm06PVG0zzLsVIpTt6MVleQ8oCAXvpN
         HecQm6lstCKgux5WLBcDQVKFm6ABYpy2hiT2+ZXtsSk+P/Eg42bxAxLbaFhItDzEwiYM
         Ob9gREdEFuN3fSGd+ooL4a/ThXkLYFgQEKGdo8btKeysHQ80NKy3OvoNwfolFdh3jjrn
         JLtFeldsJ+M9t7MY32lbNjaT53nxnaf07mPeGoFBnegbyCJg+9EjGc+NgF4pIDISMZ1/
         ij4/Z5oHEG0kPP5mf7klHwatwTv4bput9ZBprx4wfSJ+luAPDTg0Lc5dhC1km+apZmax
         RNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713114633; x=1713719433;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xC+CgHu0hZp95mkShXk7bVJiJYmZXJz30ed00tC9XpU=;
        b=oeVgJLb1wNhDCxX8pTJSfAWkDTSEFzQDrhXNzDv/Em6e6+9mjmafAR927FtxMgp0wH
         Ih3F9mg5BEmsyjbR2sIYCkugFUpQUePoM06Dy3zUJh5jAOPks4nY6it+36hJac2Ap7A9
         hagAfzkzwnhqsx5ntZ16s+IvnjqeG474mVMySd4z/w8tUKkSaVPz1GW78E2FKWmeGY3t
         kLwq/jlnxCXalqYnJS82Op7sG7UlGqh1UrhmS8RHNtppwaUvmq6SYUJxXNmImqAkCIdO
         UWJv5FcbSPUgBJ9gSFY8krp7OwKCSrCKRVe2m1drQ4MZNcU+0FBchgvERFswl89yTj0k
         1Hdg==
X-Forwarded-Encrypted: i=1; AJvYcCXFJBBp2BammKhNTVTIF7Zm4Tet4ki5T4u6r5F4LZExv0QJ/ZWsCiG35JySA9N066amFYcIIl+fFpPIY8xaM97BDbzJmfPswJj+rH38ZuoXyedX/X8TKPV9WSXTISOqfZU=
X-Gm-Message-State: AOJu0YzVYBvmhiBlxq6F2YpDhQz8CKU+liBoYSUzC5z6l28zS5AF8xCd
	gIW8OcFlEx2+X/RVGILYfeOiaZGVTfQ0O4DxLfmZeNh0ZQLrVqh8
X-Google-Smtp-Source: AGHT+IG6Q5TRkwbNsPDlR3rOcEVnJOou1k8+3xXvmTx/tkKcvtiGmC7CzTeMH7NlAQpBNR00FRhMKg==
X-Received: by 2002:a05:6358:9686:b0:186:1084:2837 with SMTP id o6-20020a056358968600b0018610842837mr9744693rwa.0.1713114632828;
        Sun, 14 Apr 2024 10:10:32 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id s17-20020ad45011000000b006993eeb2364sm5171741qvo.13.2024.04.14.10.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 10:10:32 -0700 (PDT)
Date: Sun, 14 Apr 2024 13:10:32 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <661c0e083f05e_3e77322946e@willemb.c.googlers.com.notmuch>
In-Reply-To: <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
Subject: Re: [RFC 6/6] io_uring/notif: implement notification stacking
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> The network stack allows only one ubuf_info per skb, and unlike
> MSG_ZEROCOPY, each io_uring zerocopy send will carry a separate
> ubuf_info. That means that send requests can't reuse a previosly
> allocated skb and need to get one more or more of new ones. That's fine
> for large sends, but otherwise it would spam the stack with lots of skbs
> carrying just a little data each.

Can you give a little context why each send request has to be a
separate ubuf_info?

This patch series aims to make that model more efficient. Would it be
possible to just change the model instead? I assume you tried that and
it proved unworkable, but is it easy to explain what the fundamental
blocker is?

MSG_ZEROCOPY uses uarg->len to identify multiple consecutive send
operations that can be notified at once.

