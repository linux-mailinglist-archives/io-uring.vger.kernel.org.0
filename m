Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7D544525
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 09:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiFIHyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 03:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238487AbiFIHyG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 03:54:06 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B2F9
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 00:54:05 -0700 (PDT)
Message-ID: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654761243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zX6BgnUEkYZKG1WptqMgRJ0986daAcIJ3FoZZPmKIbw=;
        b=IHWP28bgA4CiFmmfsNjMaRN+1zml0CvA7RCKGflBKaf85G8x4iy211TF4uHUo7gifIr2TP
        a181VGOmBV+bG0r5HMjfAB9539WeMbkw4HYNcgNsvUWtbgNx4bYHGLYwtov7ZAU4BDLupS
        4IZWKCM3fpFOY9toN0nQZdCY9IxR71Y=
Date:   Thu, 9 Jun 2022 15:53:57 +0800
MIME-Version: 1.0
X-Mozilla-News-Host: news://nntp.lore.kernel.org:119
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
Subject: Possible bug for ring-mapped provided buffer
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,
I haven't done tests to demonstrate it. It is for partial io case, we
don't consume/release the buffer before arm_poll in ring-mapped mode.
But seems we should? Otherwise ring head isn't moved and other requests
may take that buffer. What do I miss?

Regards,
Hao
