Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A851701B
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385213AbiEBNVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 09:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385210AbiEBNVG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 09:21:06 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4118DB7DB;
        Mon,  2 May 2022 06:17:38 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D8BAC5C0089;
        Mon,  2 May 2022 09:17:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 02 May 2022 09:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1651497455; x=1651583855; bh=Re
        UNB5qURC1x6lVfQVLPXptH6UKZn9HvHv/GBtLg1r8=; b=o/ytHf5mWgj1XYJ48V
        YNMhE+RdxqOxN2l4Oz0JV0ZJ8HSxMbxXkHdRDuX3lAJ/WsTs2DYy1FsXAle7wiJM
        AXnlbUf1H6DSDd4eCqG5c0QJBSKmGPzvlf/5+Ufi0YTVw+ZevQv+MgWAWArGQ3H2
        WyJ1gId21z3xTPulBr1I39xfVUmkwHNbGobQghhKwgEWh9By6B1s5yNTxhKP5aHw
        9Xx9aNvBU73NwItmo1DMWbjpkj2tSIQejpAY3YPdoE/fB79hBMj+/dgcxqvGBdfb
        OJv4Ns6/gviVwWEAtmGAcs0+wQ8YjC+fuqiLf8rKHb4phZeGOqAFsYloUhlX2tDM
        RE4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651497455; x=1651583855; bh=ReUNB5qURC1x6lVfQVLPXptH6UKZn9HvHv/
        GBtLg1r8=; b=v2fHZeUsa1HzjFnENokBZVERtuU/DS6fo1d3j4gH8cYehUxp0TQ
        Acgv2dGpUH7lIc231gVslpwnoLg72WUy9IvalFBBUYJhG9nrF+UCMqZKc0522+53
        QN3JDzCDgGEGMo6j4GU45UNO+BkKwXNnyCzSHRrzx1Go4zwOsX9TFsxCtx7ANl4+
        aG2auxt07O3X5vuWAkZRTAGEL4fQTArEiLOubKEQmtdszGvMW+kV3o5uo0EhgJlN
        pjfVgL8LP/J5+EFPHQA0sU9oUpol/+cpw7+g78+1gQK58boIvcMYAzSVCprzy93M
        MCMzmXvtJCd0ICQOdmVLWx+R1PJ9itDxrVg==
X-ME-Sender: <xms:79lvYhhKUjtopLgrujDk0-uF4cMvJk0A7wGUMNkQXFetGoojB4puNA>
    <xme:79lvYmA4sZZUYWi_pDly5MsQnTGk8M8gIVpnz3GVdQBcCChn3UlWQOGW-TUdyB2Lp
    BkoYJudM5wuBw>
X-ME-Received: <xmr:79lvYhGZ-5GS059KtRjQyL-KJG0eiZoXkR-sUuJOF16_BHjTlqp00zUTsBwkCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfhufevvfgtgfesthekredttdefjeenucfhrhhomhepffgrnhhivghl
    ucfjrghrughinhhguceoughhrghrughinhhgsehlihhvihhnghdukedtrdhnvghtqeenuc
    ggtffrrghtthgvrhhnpedvffelhffgvdefueeufffhgeekgeehtedvudeikeefudejgfej
    lefgleehfedtvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:79lvYmTeNFKxc22-4DensirrktA3_tGVi7b6lZDCLptp_JH3H_MJyg>
    <xmx:79lvYuxMxHiCvYqEQO2FfXplWfl0eCIDxjaEGOCTSKo9DBhcutfM6A>
    <xmx:79lvYs5kJ9v9SKa7IYueaZdi-0fYg_FWsTm0jdjl3XhYfXZ9qbnPBg>
    <xmx:79lvYi9WHiEdEGGUOLar5bHZQJrHt0A56UtKUjZPowiyzWnD-ZxwmA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 May 2022 09:17:33 -0400 (EDT)
Message-ID: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
Date:   Mon, 2 May 2022 16:17:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Daniel Harding <dharding@living180.net>
Subject: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I use lxc-4.0.12 on Gentoo, built with io-uring support 
(--enable-liburing), targeting liburing-2.1.  My kernel config is a very 
lightly modified version of Fedora's generic kernel config. After moving 
from the 5.16.x series to the 5.17.x kernel series, I started noticed 
frequent hangs in lxc-stop.  It doesn't happen 100% of the time, but 
definitely more than 50% of the time.  Bisecting narrowed down the issue 
to commit aa43477b040251f451db0d844073ac00a8ab66ee: io_uring: poll 
rework. Testing indicates the problem is still present in 5.18-rc5. 
Unfortunately I do not have the expertise with the codebases of either 
lxc or io-uring to try to debug the problem further on my own, but I can 
easily apply patches to any of the involved components (lxc, liburing, 
kernel) and rebuild for testing or validation.  I am also happy to 
provide any further information that would be helpful with reproducing 
or debugging the problem.

Regards,

Daniel Harding

#regzbot introduced: aa43477b040251f451db0d844073ac00a8ab66ee
