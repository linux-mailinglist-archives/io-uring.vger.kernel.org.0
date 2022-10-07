Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCEA5F7D54
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 20:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJGS20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 14:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJGS2Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 14:28:25 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03404C7050
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 11:28:25 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b204so4281798iof.2
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 11:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1OvETqK25CGCn8df4ajK5B8qsLsMuujr4O7Kuevm+I=;
        b=YsX/r+r8Djf8aOppoFHRiwRUycMNxTsA61gwuCIf/uUuzxyP0e1Pskl7pOGqMj+HEO
         qX1B0ZfnzDYBI2QHCx000HLwuEWQx83ktQAUWJZ1A9BBVtIvHWwAxtNRYf7TeKeBo2YJ
         j0+0o+zmZM1sraiBfnUhMlb3x3wHcXrlYxnILwpaSn2gvsMgB3mekzTXrWTKCQ1DVpnk
         SmTZ4s7liOL1pd3zCmUKv1sIh/d2eY55C/u4I8TSoivQOKfrqXuCkHmD4DqztYx8GhJh
         iCHeC4ZMMEqEHGgsvkyX1/YsRNpLPgYxG3A5onOwx70MyYZ2HtAB0QXaFPOvg0ZR+7Yn
         Q9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U1OvETqK25CGCn8df4ajK5B8qsLsMuujr4O7Kuevm+I=;
        b=t328zZkIuYISlXV/di8c8WX8qxo5f3ES1b3otGrSFbnfHv8/ABc3KW6KhxEOOLavGE
         hh//Iqu1Xv6TzJkoyFPvhI+JWVwoL0n14PnVmreo9TsZZMN5170/VbkYCVO9DZf00w8Z
         ebrqG2eBq/nRM0SnUV+eajXLLYM7jgOhQqNcvbBIXudbJszMSKhcKeTDjY5UlHBdAwBj
         XiGC0q6SHNffkppFIT/oSLIvUfKBwDMob/zbecVhQ/Qe6AwUxjG5PqkRvwJHprLb4CIf
         H62sHqKFsUEnHNe4qllSykmnzuv65IlMjrRqqG6hQPaaWjYdaMPz67jdIdNT/7Fxv7xD
         GboQ==
X-Gm-Message-State: ACrzQf1sK9suaOqLtZaQwXow393SkMIkXmX5PPlxHmKKzJtY7wUNbN9v
        MjBoKfriJ2VZyU1nap02l7jl8WXPjQ8qtg==
X-Google-Smtp-Source: AMsMyM4cw13M9j0GPiP/oE2XckFA/Km+RAeUP56y9IRWiDB+5+noX10aBqA6cREkW12MEF+rKEf9HQ==
X-Received: by 2002:a05:6638:248f:b0:358:4319:69e8 with SMTP id x15-20020a056638248f00b00358431969e8mr3221645jat.30.1665167304100;
        Fri, 07 Oct 2022 11:28:24 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z29-20020a027a5d000000b00363582c03dfsm1118324jad.85.2022.10.07.11.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 11:28:23 -0700 (PDT)
Message-ID: <cf6cbd11-e0a6-3d5f-bf93-ddc393e39fdd@kernel.dk>
Date:   Fri, 7 Oct 2022 12:28:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
Cc:     Paul Moore <paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The msg variants of sending aren't audited separately, so we should not
be setting audit_skip for the zerocopy sendmsg variant either.

Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
Reported-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2330f6da791e..83dc0f9ad3b2 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -510,7 +510,6 @@ const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)

-- 
Jens Axboe
