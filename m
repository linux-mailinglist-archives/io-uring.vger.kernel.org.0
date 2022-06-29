Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00A955F26B
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiF2Ab1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2Ab0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:31:26 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9502B190
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:31:26 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id CBDEF7FC32;
        Wed, 29 Jun 2022 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462685;
        bh=AXQRAB2/qrXWRt1ICQDbGF/Ehk6V3S/1KIBewuAayzo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZWw3+cC69dCu4O4yflOL7A3RpfR8qZNvDq/J9no3aA4iqyCGjK15u5Isnqj1tydsX
         J7jddHDmkch7j8+Me4mOSvyMmoK2AQKTDy7Cg8lHo+oQgIpTw7dyQFmTWBw4AgAz1z
         WYMKSKx2vPVEdVfw3ogYyGAIux6DG7DRUi50sU/WNHEnbf43w5usW+1taWWDlSK080
         mG3dUQoPbG2NCpPJMhc88GVzAR1QbeUzzexO7LWlI9PGgJqHA42N0zMPWS/kzH1fN+
         P4dI4oPIIBAW9jwtkIPfW9Q65t43UBs5fta0Xw7eybPJwZ7UgbAI23X2crbZx3kGpK
         hOL4GUZT7YycQ==
Message-ID: <ca43fd3a-0a8a-871b-14d5-6f71dbbd7634@gnuweeb.org>
Date:   Wed, 29 Jun 2022 07:31:18 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v1 7/9] arch/arm64: Add `get_page_size()`
 function
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-8-ammar.faizi@intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220629002028.1232579-8-ammar.faizi@intel.com>
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

On 6/29/22 7:27 AM, Ammar Faizi wrote:
> +	while (1) {
> +		ssize_t ret;
> +
> +		ret = __sys_read(fd, buf, sizeof(buf));
> +		if (ret < 0) {
> +			page_size = -errno;
> +			break;
> +		}

Oops, this is wrong, I shouldn't use errno here, it should be:
    
    page_size = ret;

Should I resend? Or you can fix it?

-- 
Ammar Faizi
