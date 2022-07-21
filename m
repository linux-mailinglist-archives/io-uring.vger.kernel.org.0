Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E263D57C93B
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 12:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiGUKmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 06:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiGUKmH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 06:42:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E497481C3;
        Thu, 21 Jul 2022 03:42:06 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id C4E3E7E24B;
        Thu, 21 Jul 2022 10:42:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658400125;
        bh=RCXThBtAq0TfDuJT7F2JB16g3t+iEe5qppWuFWN4zH4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R9UlvmChjdYvJMkWmizigTUkgmR24APhNXRyZGXeI/LRC8O2qON5i9UORYgIgOHCa
         yyhh3fNz6/QggYAB0twPiFvc/FxBxjBefGfHOCrK/8PlC6BkVVagS2/fyV7DOnPnB4
         sGrTc/UtmHbD6xJfMeKMetQZdqHuH/ciCimKEEK/X4K7lvxMdDB9LLRO5BECqw/XNF
         89/WNMljteFCZ98waahwYLDseNb8tR5dOBw+kdTVzZJ3xALjDj7TpM/gZogPJp1XLn
         h4GAtapN1daOgJQX4YYfPqkYZOThQ5b7PYsr67kk990QTrnMjMqatyfJ37pBgSdJvP
         AvlLOL5OJ+/5w==
Message-ID: <beae1b3b-eec3-1afb-cdf9-999a1d161db4@gnuweeb.org>
Date:   Thu, 21 Jul 2022 17:41:52 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
 <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
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

On 7/21/22 4:48 PM, Dylan Yudaken wrote:
> What fs are you using? testing on a fresh XFS fs read-write.t works for
> me

I am using btrfs.

After I got your email, I tried to run the test on an ext4 directory and
it works fine. But fails on a btrfs directory.

Any idea why does the test fail on a btrfs fs?

-- 
Ammar Faizi

