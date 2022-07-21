Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB057C7CB
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 11:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiGUJiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 05:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiGUJiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 05:38:14 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF780F7A
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 02:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1658396291; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:in-reply-to:
         references; bh=9pRKfSmTw60VROv2qKyBvu4ild21cpmvkdYUn9EtqbM=;
        b=vwqJWE3Lc7gzgQuotRT4IkMM3bmvXcjO2kbL0+zraRhUUoIZ0Y8IsH/KLywueaT7ZWgRIC
        tXHmjCLHjWPMz/peX4lbFx4NoJFzqbfygZS5yER01fl+ZRrIEiTkkEGUMUl4CduH5/tqG3
        N3zYBjOpemgqbaQxWYgF60qRD4ztmfw=
Date:   Thu, 21 Jul 2022 10:38:02 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Quick question about your io_uring zerocopy work
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Message-Id: <ER6DFR.59DVNSZLHAFU2@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

Good job on the io_uring zerocopy stuff, that looks really interesting!

I'm working on adding a new userspace/kernelspace buffer interface for 
the IIO subsystem. My first idea (a few years ago already) was to add 
support for splice(), so that the data could be sent from IIO hardware 
directly to file or to the network.

It turned out not working really well because of how splice() works. 
The kernel would erase pages to be exchanged with the pipe data pages, 
so the speed gains obtained by not copying data pages were 
underwhelming and the CPU usage was almost as high (CPU usage being our 
limiting factor here).

We then settled for a dmabuf-based interface [1] which works great as a 
userspace/kernelspace interface, but doesn't allow zero-copy to disk or 
network (until someone adds support for it, I guess). The patchset got 
refused on the basis that (against all documentation) dmabuf really is 
a gpu/drm thing and shouldn't be used elsewhere.

My question for you is, would your new io_uring zerocopy work allow for 
instance to transfer data from storage to the network, without 
triggering this "page clearing" mechanism that splice() has?

Cheers!
-Paul

[1] 
https://lore.kernel.org/linux-doc/20220207125933.81634-7-paul@crapouillou.net/T/


