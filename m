Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0C66C063
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjAPN5q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 08:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjAPN51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 08:57:27 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483692365E
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 05:54:17 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 4FA518186B;
        Mon, 16 Jan 2023 13:54:14 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673877256;
        bh=pzLpp+nXLI3iUDDyYN0QmNfgXUH3B3XL2cx4MfFu90Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LuDPQ94tnXw3FhkzRg1FQ/kWaWuMJ/f8rwfkQfDVKSvpDH4qkJTn7n2bXivPGfCmK
         4r6Le1gnWucfFQQZ3NhsCxuihDyaQ/Hd6wtHFMFITeSXasIReGpHFCxZv+ricueb00
         M4+H4y7bcXVFmV3myKrfxAYHCK7Kb56sew4nPTXjzQFcplOMHv7ZMgKWn4bcp7VlNg
         r32LJ/IIoj0cCUBRcffieS3s/hw1MBaoUI0814+fkTFbEmdZkBH+xGm70RB3GcSMb2
         +OPbqXroCUDSadqS73dmDV0AtEz4nCOKQp/mnXbCwK7IPiJ0nabwdnzFTC8iOZaaLA
         AzAT757JNLqVA==
Date:   Mon, 16 Jan 2023 20:54:10 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Mazakas <christian.mazakas@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [RFC PATCH v1 liburing 2/2] README: Explain about FFI support
Message-ID: <Y8VXAtctb3ISCj8+@biznet-home.integral.gnuweeb.org>
References: <20230114095523.460879-1-ammar.faizi@intel.com>
 <20230114095523.460879-3-ammar.faizi@intel.com>
 <3d217e11-2732-2b85-39c5-1a3e2e3bb50b@kernel.dk>
 <CAHf7xWs1hWvqb61tpBq63CLFvSk=kfAn_nq_2t2gf7O8V9qZ6A@mail.gmail.com>
 <34a2449a-8500-4081-dc60-e6e45ecb1680@kernel.dk>
 <CAHf7xWuX+c1uhPEsq47u9CyqztoGqG4BLwXSen-i15zM1ZFasQ@mail.gmail.com>
 <61b6a406-a657-28b7-3da7-a2ea817befc6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b6a406-a657-28b7-3da7-a2ea817befc6@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 16, 2023 at 06:44:40AM -0700, Jens Axboe wrote:
> This is great - Ammar, can you incorporate that when you respin the
> patchset?

Roger that. Will respin the patchset with that incorporated.

-- 
Ammar Faizi

