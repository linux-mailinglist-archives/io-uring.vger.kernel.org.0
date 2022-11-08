Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077FE621AC9
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiKHReo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 12:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiKHRen (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 12:34:43 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13278E0D3
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 09:34:43 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 356A6814AD;
        Tue,  8 Nov 2022 17:34:40 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667928882;
        bh=ikxbiqv9fdzaYQeXKOfibamLcFHMD8x10/hCfx20y08=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=N4wXJl7IwpS+oqhdyVYn1ukoxRk31FTqsJhZrAf+R0eKIjuA02N4jlwyg6C8aQkKx
         XDSZPHQ1wDT0AhnW5B8mGEQVq9waGn9l3/8+u9v63iZoZMXhYEB6UCEHOruPl4vEzS
         nnnqgE+xYPMRm2JHALcKCztBC1xAPHyS/g4Fn9y1QzSwZqh4M45zTkan+DVhR3QpgE
         3GfR3qO/Rnt8wSDkbBkPP0OTwPsTqTTotgyR3yPTsggqjKTiJudcWr28aHu3/OVG7i
         0mT6dinnPCVaf/XUjMY0wvpCc6DG1ZsOzOwv1OZqxZ05yLD3gqCP3SPQ6hbONgWLzF
         W7UCkXPL+M5iA==
Message-ID: <ccc451a2-efc3-f61a-ded9-cc2082be2b21@gnuweeb.org>
Date:   Wed, 9 Nov 2022 00:34:38 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing] Alphabetise the test list
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221108172137.2528931-1-dylany@meta.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221108172137.2528931-1-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/9/22 12:21 AM, Dylan Yudaken wrote:
> Alphabetical order is commanded by the comment at the top of the list, and
> also would have helped notice that skip-cqe.c is repeated.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>

Right, I've been trying to keep this list sorted alphabetically, but
Pavel doesn't care. Let's make this list sorted again.

Acked-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

