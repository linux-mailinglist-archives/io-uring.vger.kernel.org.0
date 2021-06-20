Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAD3ADFD8
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 21:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhFTTJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 15:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhFTTJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 15:09:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CA5C061574;
        Sun, 20 Jun 2021 12:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=xZoJUVoPO+RB8SESdfTr4F9sc2D3ixJYDrih1im5nmc=; b=T/tSzCPtHT0j0ZY9JyGxnmn14E
        LIvBHG6aFefA9Tx+Ifsds6ZPoHvJJezKPwz8wHoBtuFffbQWOA8NXLxglUcUYQ2NrYNHy6Vp+SBtg
        pIDZp6GQHspR2WvPcnh3tPU8ilnybJrrdAl+TtVJ6n4pRfLDF/KyUz3IwxcBMkyveobiPoXi+oBPs
        UZVkOPEj6ei7jg6ikzK6JoZ0A3lRrMPTRVSMzdDgk8ZD5NnyEYkSLqhFam4ZZXuqcN1FDdip0Zbq1
        E+wMR4yJUUSMpLgeRSXRUayTAXo7/rQaEvP3FQ83mv2YJSSKlDAzH4BkpQKzltBD131tekAos0nQq
        5x7kOgGw==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lv2mr-001TN2-4f; Sun, 20 Jun 2021 19:07:17 +0000
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c5394ace-d003-df18-c816-2592fc40bf08@infradead.org>
Date:   Sun, 20 Jun 2021 12:07:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 12:05 PM, Olivier Langlois wrote:
> -		return false;
> +		return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;

Hi,
Please make that return expression more readable.

thanks.
-- 
~Randy

