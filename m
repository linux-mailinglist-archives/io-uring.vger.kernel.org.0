Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5933FBC8
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 00:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCQX0i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 19:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhCQX0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 19:26:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E6EC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=oVVmUKaCYGAdctXmu/Xa4KvJoMIwHQoMrtOQyE15w18=; b=o5VJCjVH9jv/HT60kq+kkOW2W/
        YQqrqSk5B2rgvFnxHo9P/Cf7qgOyz6eMk7319gjg9JtlZsTS+LlJ7ND2oPcZGegvx7pcDeVgs3gWR
        LxD174qDimDNx0dcFLhOXuGSE+bawTsLdg5syIUu+gG6TtT8060FF5nQ9ouQj4x3LeGTyXbawM1c5
        aDdqD9Ejvpr6ItDeFINAYCBoOOF8+8EFoECgsIJZhUvc/12uK45OwCn426Q6CLX91ee2x85del+Uq
        QcDMbPEVPo2/ZZ/VEkxqofmfVl0lcAZQTCMv1pDRPNMFxvLRmXxs9iNsFF8suAGuwbd0QrAwBesA6
        JuyMzHP/lVfPHNt4MFdWMS+4PX3Icv64YA3FLZdhHfkbl10KHeoSUzUDrIEsh0B0G/dJqccLouTQ1
        IRIrKa5fPC2YTmvX8C5Vs5Y8z9B9iiOozxP4VqUcLZkwrKHNANh26ro9YnN+bdXBAqUIZ0WivhXAZ
        OWWFa7Fss1vYUskNe3+VkDSK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMfYQ-0001UW-Il; Wed, 17 Mar 2021 23:26:18 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
 <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
Message-ID: <e15f23a2-4efc-c12a-9a4f-b4e3c347ae63@samba.org>
Date:   Thu, 18 Mar 2021 00:26:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

>>> here're patches which fix linking of send[msg]()/recv[msg]() calls
>>> and make sure io_uring_enter() never generate a SIGPIPE.
> 
> 1/2 breaks userspace.

Can you explain that a bit please, how could some application ever
have a useful use of IOSQE_IO_LINK with these socket calls?

> Sounds like 2/2 might too, does it?

Do you think any application really expects to get a SIGPIPE
when calling io_uring_enter()?

metze

