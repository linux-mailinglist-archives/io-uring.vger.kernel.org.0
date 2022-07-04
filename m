Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EB2565D7B
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 20:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiGDSXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 14:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiGDSXr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 14:23:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38B1B36
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 11:23:46 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id C5FA2801D5;
        Mon,  4 Jul 2022 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656959026;
        bh=LkVyQH9eAvRi0CHInjMIg746Huz2+OY1ZBApgtfs8T8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kAWfWk4Kh66GN9UvRWQFeLoOQgV/R+SY60v2857nhsOsgy+cWVRKj4VB25vnvNEbq
         2kG0X7mK5+RMNplZk7f9pIRCVLDzN6mRkvyWZPTTsID3YzSbLw/MdERjLUy8FKWAVv
         YU/CgjApgwtBYQUicJqpTseiro509m5GD8nTSP+oY6X2m3BoUCM54r+OrV1RrV7XD0
         LRJfLYP3vanKIgmH/kUCtwV1QUT9tnigCTIl19M+lNbN6jsgTYcr3N55Eygywpiv69
         g7M+Cd7xNXsD6WRMK95jr00g074/zKK9olTN6zaxyH8j2/YQQnwX+LC3OFujzs5OTi
         6kEQ9x2r7GCTw==
Message-ID: <3b8da014-41f9-6640-589e-63795ac0ed67@gnuweeb.org>
Date:   Tue, 5 Jul 2022 01:23:30 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v3 05/10] arch/aarch64: lib: Add
 `get_page_size()` function
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
 <20220704174858.329326-6-ammar.faizi@intel.com>
 <CAOG64qPdVWFE0ZCie3NiDJb42u78ZNtmOmEW=-=oLE6VAn80TQ@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <CAOG64qPdVWFE0ZCie3NiDJb42u78ZNtmOmEW=-=oLE6VAn80TQ@mail.gmail.com>
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

On 7/5/22 1:18 AM, Alviro Iskandar Setiawan wrote:
> fallback_ret var is not needed, just do this, simpler:
> 
> static inline long __get_page_size(void)
> {
>          Elf64_Off buf[2];
>          long ret = 4096;
>          int fd;
> 
>          fd = __sys_open("/proc/self/auxv", O_RDONLY, 0);
>          if (fd < 0)
>                  return ret;
> 
>          while (1) {
>                  ssize_t x;
> 
>                  x = __sys_read(fd, buf, sizeof(buf));
>                  if (x < sizeof(buf))
>                          break;
> 
>                  if (buf[0] == AT_PAGESZ) {
>                          ret = buf[1];
>                          break;
>                  }
>          }
> 
>          __sys_close(fd);
>          return ret;
> }

Agree with that, will fold this in for v4.

> with that simplification:
> 
> Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Thanks!

-- 
Ammar Faizi
