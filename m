Return-Path: <io-uring+bounces-9956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CEEBCA5AA
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28149426C33
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767BA226D1F;
	Thu,  9 Oct 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dbEp7dvw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40031635
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760030193; cv=none; b=QhndAJsMwk6AJDQE4Rxaqb5S3ccb4U49zoo1xOr+xrs6pm1Usc2BESbwLBLvvfIk9fJSZAo+1HC/CY7cDyK5DqAYrkOzozF/kBZhULgVcXlHQZ1cC3hzk8dNiBSWRE6uezTwmPLAHA+kG4lNee7tw7/QnecSOz/UER/Q5zXcO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760030193; c=relaxed/simple;
	bh=eTvKsfZWSIZw1/7QA+vIwYbOlKcm+qbfHpFsYq87r74=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e+zwN2yyqA7h4HrNKf988HehDBTnurRDasrKMYnQDWU+/Pwr13CSZZm7ZV92VOB4CDkO7V4ajr4tNktpolSG+luJL7XiM12QEhC4rjrWZ2QVTKUTEeNQec+ywCovbEx8ObO12y9m2KfFnADOCeZmfCHAlc4vb3KoCSs+ESIlrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dbEp7dvw; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-91fbba9a8f5so110072839f.0
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760030189; x=1760634989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1dgrxHtWEHMr9Hmc1PtIDiyAxbzIwd/8rFxzt/ZgVmg=;
        b=dbEp7dvwqQbNVafvpXMQZFK6gAft0KKeAijJ5hQLIxT3t7G6B0CfZEvpl4JjsEGe7e
         NDh4R+I4XhuzEQ79KdFlm/zVL2IlXZWi0hGO56ka9PpV34RPeszDfxC63U6q/R12UOvD
         j3iHHtSqLH8b4Q1I2zeMAkGqn3Jlvn5CI3yzMzZbSZdVBYtCue0Uh5Qq10AuAiCAgf1o
         TbXeeXh8yUQ9b6jGbrs1onH6po0m9YDkgAGxx+vxY0hL0or4BN2q4BqDpBN1DtieKXNv
         VZRV2qEg2cBCFFn2650EL4fZq9uUZcdHEU2acegfuok21XCELdp5AZ7GuH8/YmcFAf5s
         7TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760030189; x=1760634989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1dgrxHtWEHMr9Hmc1PtIDiyAxbzIwd/8rFxzt/ZgVmg=;
        b=Z8Lgfo0j/0S8/WHywqYuwaC+Va8DnuE/ga01Vgp3647KS50PCkoOEXTHHpipxecku8
         PK2Ex6LNhqQ4zhlrHsHDpHdRKG+b8Ku0ktLMPLA7EPNnxZv6y8IxcBGWgc6A4NKA1Nek
         zrj4sP0aisi81EbpHNLCi0QbaykBdVP8LWXeL66Bgm/7/L+xm6W37Z/OCX0MlU3INvkm
         6PnDIVsj+zzaNKhOcuYjChtgb2WWoURrkZfUS03T4NwzQDw+AglVEzAYtCnQJIfy1Kw5
         5CVMcgVA+0PxFa3/xUo43iNjREN/KzMRDepIBDj7x9L2rNIliIZxYSTm4KY28lHQm4jh
         Zctw==
X-Forwarded-Encrypted: i=1; AJvYcCWDcPGNP5w4bX5ku6ChFMCOufZW79/878Xp+2+VYLYkkp5F3DWlF69DkHeyTtDhoFFh3i1uMFTtTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZn33wvrHdZP4GJH+Qz4GdW7dCW5qTFtit4bJrXtMZPhXAfvsA
	8yNxBhUTUu7LZIBIpzG2aSB2mzvH98fkt4Z3mAFeccG0qmjhs0reHk3FBRD+3XFcuPA=
X-Gm-Gg: ASbGncsPSoreqy/eBH2uga99S0ek3xVqlWxQMuxZnch0HhJ26DzwUmusE6Wp8fDO2qN
	49oaY5odkWnMMJWNUJMQKxS5m1sAXpatH2/p1Gr5xJgs/HUfMmZU06gZcBR1tqbj8vlpTNn6nww
	T2lYZ0BOkb46Bf5g9H3VpgSe0wyc4GCofsiTD5/bFP7XwxppCkW+wljCwdJpcpsRBP5o0rQQtCu
	7Jzij2AUgGUiYFFn40PDXlsZMrnw3VRY7WOVkbCZ8wp6pTMu/lLt5br6Jn1N8TKSzksOnpj4vag
	GgZNCAmV4FtJnlyCur3Gbt2MIjqsdgU6i1Re8sTnlHnjsmTbvu4DRJc0g1Fw6sBR7rQKYxeOPpD
	6bsjyhsb1s9U+V/sTuWEeM2IGJYFQv/fOsH/kJslRAe2wXEfB66zheQ==
X-Google-Smtp-Source: AGHT+IGKPdE2x2LdF7TdjzoNbTWXrqAezlnnNapsUBSI3DIyl8MC6bA6FwIbz3FT3WNkp1tcJdzaQw==
X-Received: by 2002:a05:6e02:1488:b0:42e:2c30:285b with SMTP id e9e14a558f8ab-42f873d1c4bmr70129165ab.20.1760030189113;
        Thu, 09 Oct 2025 10:16:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f90278522sm12625795ab.13.2025.10.09.10.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 10:16:28 -0700 (PDT)
Message-ID: <d9f47040-4a12-4584-8293-8bc2719cf263@kernel.dk>
Date: Thu, 9 Oct 2025 11:16:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_waitid_wait
To: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68e7eca6.050a0220.1186a4.0002.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68e7eca6.050a0220.1186a4.0002.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

-- 
Jens Axboe


