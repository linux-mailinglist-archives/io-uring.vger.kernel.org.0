Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33FF561B6C
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiF3NcU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 09:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiF3NcQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 09:32:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F39344D0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:32:16 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id ACCD080108;
        Thu, 30 Jun 2022 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656595935;
        bh=0+PAVsd7ayQTag0spZ+VU/O2yQBu9EJPSzFYyTEH8zg=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
        b=RXy/n+v9QYxpWyiDFXLal9G+EcYuxNbTECDj9IaQS+fW2tQqx+loaSplcx15nnUBa
         UsXt5Eu9fxN+EldXM6FhCn2rDRMaehwf+ta7FIJi+YKixnfQe1b7oddQ+X61K8YC1Z
         XyNRyaOdbUBn1tPKZ3mjw3Trjmkblajegk2TSYw+R8l6dZhdrS9b0dL+bzeb2qeSel
         mE7lX5uIMhWNkGtbQ5yIYEni2NnZUxGn8NxiKT4i9dIsrLHnFchgpfZDrVB0sG/QRD
         3tdcFcgYi29bk5JYZDYES1TGLuksNtcOB31ZQF06/6qf/4x1x9FJ8+NfQsfGmQtco8
         8kK/AtzxEX7kQ==
Message-ID: <fa7ef9b7-1643-e7db-53fb-90bec6df14f1@gnuweeb.org>
Date:   Thu, 30 Jun 2022 20:32:01 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
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

On 6/30/22 8:09 PM, Jens Axboe wrote:
> On 6/30/22 3:13 AM, Pavel Begunkov wrote:
>> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>>   		return ret;
>>   	}
>>   
>> +	ret = test_file_alloc_ranges();
>> +	if (ret) {
>> +		printf("test_partial_register_fail failed\n");
>> +		return ret;
>> +	}
> 
> If you're returning this directly, test_file_alloc_ranges() should use
> the proper T_EXIT_foo return codes.

Also use `fprintf(stderr, ...)` instead of `printf(...)` for that one.

-- 
Ammar Faizi
