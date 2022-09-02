Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4A5AA819
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiIBGgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiIBGgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:36:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37919F0CE
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:36:03 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        by gnuweeb.org (Postfix) with ESMTPSA id 9113680C57
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:36:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662100563;
        bh=aWbe5crpfkIxJYQapTBkP164Wg8Td1gWINz/T4GUD8c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YC4hn32AbmRVfsAFvtaM6pZVMg1gKMrKd941RYXSiK5vVvjBtC+/ZNXXbxqaYATaW
         Rz31yIXmwufWK41CmBvVeN5NhXmfCgXZF+Qg64jf2DXMuxs+v29leGGsnvEGhuBxy5
         uN2drwck7eoya4MHLnoqWxyZbeQOZdnATJfv0QKCK9Xz93XyVLjdxocZwyoiJbJ6GV
         Pd9I80fVDWSjUsIXmefHVHoXBQraQPeL0dvnfquXQx6j0Ia+mLLpOsUpHy5lSXlHVb
         ZpAXwrC6zhZCdkxzsNBQg1ik8xrmcE4nHqH7OOAXsiZGA0B40UtmFefUY9DzIhOWXA
         h+55IMetUgNEQ==
Received: by mail-lf1-f47.google.com with SMTP id bq23so1898845lfb.7
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:36:03 -0700 (PDT)
X-Gm-Message-State: ACgBeo3wiI7CtFlG9OH5KlhU67g5aAFuVVvtPWY9Eaj+Air1yl1ghTrI
        tiEZRY2708Xu0bG1xq3GQdr5MZIE/RzzlQ3Nuow=
X-Google-Smtp-Source: AA6agR4lHRArY/nzp1MgQ3KzVK2mXBKxFhUX4zktOpL3xKubujRCmw8K58Swcvagw9RGOCDs7o674orOEVwp5+qXF/s=
X-Received: by 2002:a05:6512:3501:b0:48b:205f:91a2 with SMTP id
 h1-20020a056512350100b0048b205f91a2mr11591170lfs.83.1662100561715; Thu, 01
 Sep 2022 23:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-1-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:35:50 +0700
X-Gmail-Original-Message-ID: <CAOG64qO71RPvk1Gh-2Axky7-FBN4x0+tk+keEFQ2737ZcJRA6w@mail.gmail.com>
Message-ID: <CAOG64qO71RPvk1Gh-2Axky7-FBN4x0+tk+keEFQ2737ZcJRA6w@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 00/12] Introducing t_bind_ephemeral_port()
 function
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 2, 2022 at 8:18 AM Ammar Faizi wrote:
> ## Solution:
> Setting @addr->sin_port to zero on a bind() syscall lets the kernel
> choose a port number that is not in use. The caller then can know the
> port number to be bound by invoking a getsockname() syscall after
> bind() succeeds.
>
> Wrap this procedure in a new function called t_bind_ephemeral_port().
> The selected port will be returned into @addr->sin_port, the caller
> can use it later to connect() or whatever they need.

with variable placement fix, for all patches:

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

(tested on 5.19)

tq

-- Viro
