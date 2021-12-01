Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFB4645F7
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhLAE2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346608AbhLAE1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:38 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9FDC06175B;
        Tue, 30 Nov 2021 20:24:04 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id n26so23004876pff.3;
        Tue, 30 Nov 2021 20:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7IcXh7hkKTNMPxt6YZo1bjq2Oa0ASN2LOQPZecX9IA=;
        b=G+voL6wJw3c+eMoG3p9xj5cgifda2ejkqCJqCQLLeSaGHJ+JKnfVBotRvVX/0sOx7I
         6C7aicypaCP+nfwUqw+9GgnLaR2+E0Z9BaOMfv5bxQ/+EiZP9sEE2pDKFhmbp50KMs1i
         WCLE0WBK5FO9w9UtFchHY1Sf2OIuxQao92ENqR5m8o70J7D/TD5/ffzmblQ6eg3adjbx
         kx7AGLbanbtH/jgwLvctaEdQlBzpXpf0aufSTxSocbY6r2+CE+20IiWSqy1KK3Cr4SSe
         DX1ODKLbUZL45dcKPm3Sxm7cmEQfhNT3qin/o1eFpYV2+Pl3PaZ9kcURRsH2PeAJepX/
         DI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7IcXh7hkKTNMPxt6YZo1bjq2Oa0ASN2LOQPZecX9IA=;
        b=Ae+ZirFiA8s+tt0Sl9LaLA16zBKM19rg3lOBCEslue1UdYr24K1ofI6ATFiJSHHBqL
         b06GEodYBrjrFhCqyQG5kjWFN6OwYNwC+6IZy9sryXTZORuUzaa9hYO5VfHWZ8b4sx5l
         BS71DleUw2fMO2Zm5CEFJtHsiN3LOL9qZxWabTE++XVpXp086DCY60++ZGADRs5uahxa
         CnhYrsY3nJQW7F5jx2DAgth8IJFpJA7SzpFEXUhihUSUvl1jE5xDRnWMUQE4GzcRFYV0
         yo8wSU3lj4huP1B0VF2oBg16jHyrAZqlNvM61yvlLOl7Y8VW5tK40yhx1XKInPHvRuku
         cn0w==
X-Gm-Message-State: AOAM532zWHr+Y0TOkwpszeRXEZrgu4WAT+5sB9U6eL2P8QtSeZahn5CK
        3R5IpdExtliTIZym3reak1VSIcIv29s=
X-Google-Smtp-Source: ABdhPJxLaJnjlMXWkC24b57twGFlBGMgy582WfgYrQLbB/lD8ZTWNvk/AyBOttqbm/xjQsyogkyLLw==
X-Received: by 2002:a05:6a00:234a:b0:49f:c0f7:f474 with SMTP id j10-20020a056a00234a00b0049fc0f7f474mr3616842pfj.64.1638332644067;
        Tue, 30 Nov 2021 20:24:04 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id g1sm8435444pgm.23.2021.11.30.20.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:24:03 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v3 09/10] selftests/bpf: Fix btf_dump test for bpf_iter_link_info
Date:   Wed,  1 Dec 2021 09:53:32 +0530
Message-Id: <20211201042333.2035153-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1199; h=from:subject; bh=QE4SyOAFzzmkq+EmLnqIhi3J/rXlE8epdKkKQ0ddjk0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYyHodypS5dcJxgGWq6Gcm01FTC9AoUN7RCDrNE /m9lpO2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MgAKCRBM4MiGSL8RysTEEA DCmZCmJmDZDxqlorY0oGjDyVOz8xicGLWGmSH307rEylOEUw85KOGpd3eIMfiK/Nnqg9rK5s2wHPyc /ARNL1eox1+ygPgQQUQ0haEENVe149mNIY/bB5clUNBw+8dhw26Jt+Vy2LepNOEYDIAsIC+y/s374r qh6XZm2I8MsXRuSTgWWdV71OsJ221i9gMWFW+H/ReIFwLFg1Nh5n6suRxc+bv6FdTUpn7zERR7kxxO v4c6C8k3f2fuhfQ9JMcnWu4QSiJsYfGQWVShUA/alh0W6ah9MvRYJvyfpUUL+v7ObgbCYbicBIb/pl RC4aSphiHmGciptihLOImE6FmlEw3HAdz/kIpPtLarR6fEXgAIGfeClA8LIu5YtJRj/v6eh3WK4vI0 J8nawV0icVnf9wjjMvRdKF2Ge8cYv8lmHVYnGGiLK61qeGrq0BtCBxBycYrFRmS5Kv07SSlfwqAnHm I0T+D5giFEj0fLONEz1X8U0h1tHGpnrH4Ha/YSt0LDHHQ0ZPN6uWHJhAQwls+gcoVHrc9QFxrt/amO hNfMhKbhGZuCEkRNYHpVDJFOf7452KtXXmLPHWomWisxX7E/c0Kha4lYlLFFJlH6wg1bBnRHVYyadm 8CK3YEOupz+hdjA4nV9A70shbJW6vHjAjpWhf9B1PR22DK1pa0fRWf4Rd+Bw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we changed the definition while adding io_uring and epoll iterator
support, adjust the selftest to check against the updated definition.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 9e26903f9170..1678b2c49f78 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -736,7 +736,9 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 
 	/* union with nested struct */
 	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
-			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},"
+			   ".io_uring = (struct){.io_uring_fd = (__u32)1,},"
+			   ".epoll = (struct){.epoll_fd = (__u32)1,},}",
 			   { .map = { .map_fd = 1 }});
 
 	/* struct skb with nested structs/unions; because type output is so
-- 
2.34.1

