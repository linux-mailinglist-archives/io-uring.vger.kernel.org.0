Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D779E5A9836
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiIANND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 09:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiIANMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 09:12:17 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19E03B969
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 06:10:33 -0700 (PDT)
Received: from [192.168.230.80] (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 0053E80866;
        Thu,  1 Sep 2022 13:03:05 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662037388;
        bh=ljjl+I7lVpq7DqzrbpwFmOM1P+0Ay5CKREHy8T5I82U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RqWYhcf2cBLv6HYIhKaN60ci72Q4V/AcSjub3Q9AMCYearep/aSuKjAcfxUF64eCf
         F2ufRhAPsVbw4qJkUJ9kiogNGH7GEUC4J8eHNr1EK2ebO8DUdx6ZemJIN+Bq/o2F7f
         ohiRy0UJ8ZkSHqegQRQOf9mZtz8uMkNfXsmsrfE/ONZRrl0hdQrGnyv81GZeoJD42r
         JoCUv6RFd35NNHT/dWyq3aKH0aRqSPdAKpFKFhfmURCLLvp/9Navxzs2T3BfJlGL4W
         fsiidq1lHL13qAHP6TRB81RIB49f+KCCCG9h5ponOVbfSFCLrVc9fCxlEsLFMeqRib
         9Kb21bPFc3mNw==
Message-ID: <3c36d7eb-31c9-0b46-8f39-687c40588377@gnuweeb.org>
Date:   Thu, 1 Sep 2022 20:03:03 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 12/12] shutdown test: bind to ephemeral port
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
References: <20220901093303.1974274-1-dylany@fb.com>
 <20220901093303.1974274-13-dylany@fb.com>
 <918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org>
 <cef8b64ee7b73ba5899da67eff6e395547d88ddd.camel@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <cef8b64ee7b73ba5899da67eff6e395547d88ddd.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 7:54 PM, Dylan Yudaken wrote:
> I think something like that sounds sensible.
> 
> There is also some duplication with t_create_socket_pair, as I suspect
> most tests could just be rewritten to use that instead - depending on
> how much effort you are looking to put into this.
> 
> For now I think dropping the patch and doing it properly in some form
> makes a lot of sense.

OK, I will do the t_bind_ephemeral() part first for now.

-- 
Ammar Faizi
