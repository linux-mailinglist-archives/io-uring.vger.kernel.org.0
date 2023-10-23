Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6AF7D3F04
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjJWSUa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 14:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjJWSU3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 14:20:29 -0400
X-Greylist: delayed 354 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Oct 2023 11:20:23 PDT
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3189B
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 11:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1698084869;
        bh=INx2UDdjfqNe5qUU2qqyFe4kJttCAk9C8JAuNzz3dHc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=BbFF6DNkLBmSP4chkIL5o8hdl80cNbY+5s2J6Xw7Cq4AnKt9K+sTeJadEbkt/mKd/
         kj8UEM3VMOe84omLqmLO1RWSr/aBEksJGa4nEWU0OXQxR5+9YjHFvtYa9VIondKX8w
         W/WjvTVbVulQwGP1Dr4YOnRVzf2kN6maa+FJJ1yRvT5rx8gFC6xto6tqa6NzPaOIxP
         p9rbP45FBe9MBvfIWBE0dQD6FOJCQMD9RgddS03EUBGaIf2evEEq85F/zZ8wdehL27
         /FIfFFk8ClQ/rKo0pSeZYUm6W5EtAkxnjitZAx487eFGl16x0C+tHBUIoEgWG9gbE0
         Tq5n2OU6zb9nQ==
Received: from [10.20.0.2] (unknown [182.253.126.121])
        by gnuweeb.org (Postfix) with ESMTPSA id A0FC124BA4F;
        Tue, 24 Oct 2023 01:14:27 +0700 (WIB)
Message-ID: <3cc4c3ab-9858-4308-8c96-dbf5aa1314a2@gnuweeb.org>
Date:   Tue, 24 Oct 2023 01:14:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/fdinfo: park SQ thread while retrieving
 cpu/pid
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <04cfb22e-a706-424f-97ba-36421bf0154a@kernel.dk>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Autocrypt: addr=ammarfaizi2@gnuweeb.org; keydata=
 xsBNBGECqsMBCADy9cU6jMSaJECZXmbOE1Sox1zeJXEy51BRQNOEKbsR0dnRNUCl2tUR1rxd
 M+8V9TQUInBxERJcOdbUKibS8PQRy1g8LKJO/yrrMN8SFqnxYyX8M3WDz1PWuJ7DZE4gECtj
 RPuYN978y9w7Hi6micjraQeXbNp1S7MxEk5AxtlokO6u6Mrdm1WRNDytagkY61PP+5lJwiQS
 XOqiSLyT/ydEbG/hdBiOTOEN4J8MxE+p2xwhHjSTvU4ehq1b6b6N62pIA0r6NMRtdqp0c+Qv
 3SVkTV8TVHcck60ZKaNtKQTsCObqUHKRurU1qmF6i2Zs+nfL/e+EtT0NVOVEipRZrkGXABEB
 AAHNJUFtbWFyIEZhaXppIDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz7CwJQEEwEKAD4WIQTo
 k3JtyOTA3juiAQc2T7o0/xcKSwUCYQKqwwIbAwUJBaOagAULCQgHAgYVCgkICwIEFgIDAQIe
 AQIXgAAKCRA2T7o0/xcKS0CHCAC2x/Vq6OodDFs0rCon2VBZFvnIyXIaOsJWNnIrlkNKVHWL
 QC+ALmiSwFN1822v8JP+8Fyf+HHIKVTsAPkovCnrIbliM8ZA+YTUmcLMPL+Aa05+XyZjR14l
 6Oyu9BhN7MW/XKXQnw96OE8AHpbX+Pgd4A7RtA2FGlaoBzrGlEe1B8nDBcS9ldJ0J95VKX6j
 LCJeU51msq1Q+ZyZstJ7SFsY9XKcMW7cS/aHzsayBRKtansSTkyJWCTinHn17rzkSRVcmdNY
 uga3YOBOfRIEq9LzrewE9gV40VNctY+sciMc/Z8uK5TfGIlYDTtuLmlvmw+EWjEKzwS6O0uQ
 K9YtIvl7zsBNBGECqsMBCADrprHwlhdUQBY1kzzeCozyx1AWGpyFNiFGjsRC3+UK4dhO9h6u
 Gz3OY5o0G7AV6nOniZCQofgm78NL5wdvIjL/ko5l7LNFQkU4SBjcGjn+Wc4UAWd2EpFPo/Dc
 3kTFzSlowp2+/kETA+FK7UDdwJTH/n05XwvGTZ9/pmVwP0e6iDnyJ5yIwbv28wTdIm4L3/uB
 xMp1UeHwztLk4Dcw+FX5ye/JfK3dbx0Gx8cfhAeFlVEz9z6LvtAn94BNYVd4CxE9Vh2BFFzq
 07bDQGhAN0Rim1K8uEahuKyyg2MuoDI8lvzONLbaiEw9/OgT1z+h4qyzjulXAHzxqkcjz4Of
 SqzfABEBAAHCwHwEGAEKACYWIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYQKqwwIbDAUJBaOa
 gAAKCRA2T7o0/xcKS2+RB/43pagncTq0/ywbQhjHrXtOuYDPcrbKusD1jiURWXEMgM48nV/H
 dQYTHd8mabMT0xa4NOUlDA2If2t9HvzLoNDPefP4+z41DJL6ZZNCQhLUJBh5/zhSedRF6JHW
 PiO/nWkfdUUhBTabadgUYI80djY63rG3LKmjuh3/AZ4Vb9qBVpJX0tjZSbXa47yzL7tiQ539
 u7eqoTXOy4oc5XC2koICy4DMNAEVaL2uEfY9MPHJKcsmrcwtu4w1gg8JehM/bwtphPG5J+H7
 mFZqTLyTMNfOmAKErQlwCfFzyh0uFggluVBlOLImyrKOh6+0bUZGZ0CaTE10OMTS6HgE1W10 EZJc
In-Reply-To: <04cfb22e-a706-424f-97ba-36421bf0154a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/23/23 10:29 PM, Jens Axboe wrote:
> v2: use the sq_data lock rather than doing a full park/unpark

Since v2 no longer parks the SQ thread, the commit subject also needs
to change to lock(&sq->lock).

-- 
Ammar Faizi

