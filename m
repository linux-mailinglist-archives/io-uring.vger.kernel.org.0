Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288B962CA89
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKPUSc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 15:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKPUS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 15:18:26 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25421CED;
        Wed, 16 Nov 2022 12:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=CpmqOAa1OU9ci5ByMvbNPluq1SnCp6Q8G9wYMlbnqkA=; b=X6C32Xq4IV4GAw8RLcSpomnmno
        gTBlVPOQBrFGtUKsO59I/Fetef3vR0+aSJKmewabvLbUUppoOxCLm7ahMex9AbJ0RAMz3IhqLm/KH
        GD7bPC9uo3kajIitPEXxi2f9ADrABWOmea2GVTsGFGfOSxpNCx5subNaeeAuOxc4whLER+zk1r3nU
        2D9cAXwfZ6SrRh5UF/Gb9J1ttRTpt5kCDk//0fZHqqY7rhWHSZnGH3mm6yNjxqlzv1V1sNsueE0Jt
        D0LQLkDZDnl/skU1/5GhCm2pLk8vJmJIepJpv7R6xtUsLLWoidfkvWcsYqEpIFx/eWEVObqHlOCbH
        bP++U8V1PL9NiO2oQdmSfS3e/Q+KrkIarP2bBbY8SDphaU938CTKMWK40q0mgfmIpmWQ5HGscKu09
        yu5G1ti1/EAmTcevHWrs84d9BcdqExYJAQD1FKdMLegRbXCUtG3WIcV3Snukj31kxvtroNToEmIEZ
        AhCNfrPau4wb9Y4UvYH0HSMO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ovOrV-008wnE-Qz; Wed, 16 Nov 2022 20:18:21 +0000
Message-ID: <d4ec4af9-0537-c9fa-b011-eb0f6f72b639@samba.org>
Date:   Wed, 16 Nov 2022 21:18:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>, Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
 <61293423-8541-cb8b-32b4-9a4decb3544f@gnuweeb.org>
 <fe9b695d-7d64-9894-b142-2228f4ba7ae5@kernel.dk>
 <69d39e98-71fb-c765-e8b9-b02933c524a9@samba.org>
 <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> and needs a '#define HAVE_LINUX_TIME_TYPES_H 1'
>>
>> BTW, the original commit I posted was here:
>> https://lore.kernel.org/io-uring/c7782923deeb4016f2ac2334bc558921e8d91a67.1666605446.git.metze@samba.org/

I'll push a better version soon, it inverts the ifdef logic like this:

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,7 +10,15 @@

  #include <linux/fs.h>
  #include <linux/types.h>
+/*
+ * this file is shared with liburing and that has to autodetect
+ * if linux/time_types.h is available or not, it can
+ * define UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
+ * if linux/time_types.h is not available
+ */
+#ifndef UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
  #include <linux/time_types.h>
+#endif

It also means that projects without liburing usage are not affected.
And developers only have to care if they want to build on legacy systems
without time_types.h

Once that's accepted into the kernel I'll adjust the logic in liburing

Does that sound like a plan?

metze

