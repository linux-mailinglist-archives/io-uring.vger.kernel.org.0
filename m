Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E659560454
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 17:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiF2PR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 11:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiF2PRZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 11:17:25 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B16E9F
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 08:17:24 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 09BAD7ED9F;
        Wed, 29 Jun 2022 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656515844;
        bh=HydFwJoxtT834/v+j2PM6ibyjCMsAKJ568YQ2A3+CI4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f0AyUvlJfjQCvwcwugTFbpnHb3nUlP9PEH5jHqT4nFSoyLmztH6JHRRMMg6quIozW
         tW737fQy7fexJeLbbTPUGsiKvqflmSp9VW73ejenILzFBnsVF8eObddesovGHpNADy
         A8KaKRUiV0xHe2BPEQdrrQ0V/BjCqYINkNTPlv4HkQMlOqyF/ZSEpKGDvx7vY6pT3P
         bCdJoMyNOiuL1JmIM6epk3agrXbQjpi9s7B1w5724qKh54HFJCjNr4w8cbrrXuAkuk
         drloB7kKPr/zaOFhTLpW6/bbzoZGjyo5wgOo6tB9wzekG3BJ9RvW9E5bZ+UM+FV6D2
         tDFIK0EJvYZIQ==
Message-ID: <7bade71f-78c0-916d-3846-1dbe318676b0@gnuweeb.org>
Date:   Wed, 29 Jun 2022 22:17:17 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v1 2/9] setup: Handle `get_page_size()` failure
 (for aarch64 nolibc support)
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-3-ammar.faizi@intel.com>
 <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
 <1f690153-1b0c-b9fc-4c2e-6084ebe1c0af@gnuweeb.org>
 <3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk>
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

On 6/29/22 10:00 PM, Jens Axboe wrote:
> 4k is the most common page size, by far, so makes sense to have that as
> a fallback rather than just error out. Perhaps the application will then
> fail differently, but there's also a chance that it'll just work.
> 
> So I think just falling back to 4k if we fail for whatever reason is the
> sanest recourse.

OK, I'll do that in the v2 revision.

-- 
Ammar Faizi
