Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56A066C2B4
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 15:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjAPOwm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 09:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAPOwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 09:52:13 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729972BF1A
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 06:38:01 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id F04CE8186E;
        Mon, 16 Jan 2023 14:37:58 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673879881;
        bh=fa54TgKMNV1QHij0hwa+w4aFEYLDwJ6EwJJiyWY1dNA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HwF/lxMQQmVIjkUZMmzeFZ6iY9hXde2KQuzpwz/KTPw5QWAlCiqDml7NMdn9/dHZD
         ev4YtmxQcIFU40a7tt8t8Qvk5i9xY4LP/6LrZYi+U0ge4ItgWVsK5Olsg5Gqw9hCvx
         4Dsg8f55+eWPtD4hleVg9kmS6CbbolQ2Yt33DYU+eT1g5fCvUBv7c4psTgesVrPpTE
         JIJGcjskPLSMYvp/x59xVnlMsFBWKGF2vJTFSU2Tb9nn4Uf4qNpN9lloKEvdIUnh4s
         M0sa5wwNAPsvuzhGf+iRqVdfPeJqznuyqmiHbP2LQz36+VCu/UBiwKvdg/+yPUrLcm
         hwOrRkr/ef7ng==
Message-ID: <4f920a48-db1f-e8ce-e594-cdcf6899421d@gnuweeb.org>
Date:   Mon, 16 Jan 2023 21:37:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH liburing v2 0/2] Explain about FFI support and how to
 build liburing
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230116142822.717320-1-ammar.faizi@intel.com>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20230116142822.717320-1-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 9:28 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> v
> v

Sorry, wrong cover letter, missed it when sending. But the patchset
diff and changelog are all good.

-- 
Ammar Faizi

