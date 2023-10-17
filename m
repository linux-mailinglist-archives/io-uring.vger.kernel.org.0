Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB827CB7E1
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 03:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjJQBON (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 21:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbjJQBOM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 21:14:12 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D4CAF
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 18:14:11 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c9ba72f6a1so10566735ad.1
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 18:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697505251; x=1698110051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YyE+eoJiyBmwqe0k2aZhgcAkQ0mUJ7owsxJAxWWwCGk=;
        b=ga2upFcXutWu8hWLE3UIYhPn+/0AE8kIvVpT2+jkDaRwEMnp1rP0mj1jGEoIVH0177
         qT+Piph4/vO2NJ6De83iaY/ZojcKOztZAYGdxT+yLFhiZC9ZCJ5S0pp/eV/z73V1ahlm
         4nQ/IMy43U70kVAZJN/0DQrpbys3heI0KX+2zIGG+6KtuLL94Cz5Nrwlfodj/siPSxOK
         On2QGCRm9zbwe2nAigxDWU+TL3gkaHgzhY+srIlRNLNiWgUZxXTbu5HHBqMUVAgcOCMo
         iKn6800dtsUp2vx2OzckTZp7Ti1wcJ+co7QlpwhFvfjloILA+/ppVI++jcjrLv/SsI2R
         /mhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697505251; x=1698110051;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YyE+eoJiyBmwqe0k2aZhgcAkQ0mUJ7owsxJAxWWwCGk=;
        b=jJIJzTY+70iOGCgW5CBLbkWNZ3jNFQc+Iu/n6sGX5O6d0MXkn3MavbUUMovanDpvpB
         mda3daa7WCxpuVlZqSo5gwZvbL2MPoncyrk7Yh1bfsN4e6iPr6edQHLfwFzzHqgLTe4p
         CbYYL0QQg1dFCAwhwDWkHp/a0i74p6qy6SRdUB2kkDFZKOIYa62jHXX9um8/0FY62jXQ
         yzsOO7lkprYDRNVGUK43tx9qS133kaGd5YKYVBzk85kJTMhwL/Js1tcF7smEE1MXQlrd
         i19NCbo1fTOPoAE/RRMgejeUyn7vFG9yfS8t1sPXd4Q1t1T3oIchfSdg8f2dSib+7Mcr
         4fKA==
X-Gm-Message-State: AOJu0YwubL5Gb9Mdh0WeMkNoy/glmOTzEg7EV3zStGoSvNMinpoiLC2p
        usTGiM6F80sJfuaIRRu+VU+xh1dxHcZY0myIdpF+rg==
X-Google-Smtp-Source: AGHT+IHMSMs4TeTY9CgnmHF2uwIh5w8bCOdYO5OpGzaF1GowsNIpq3iD0dtck5RNFS5Ee6zfDxE0Zg==
X-Received: by 2002:a17:902:bd07:b0:1ca:28f3:569a with SMTP id p7-20020a170902bd0700b001ca28f3569amr877708pls.5.1697505250769;
        Mon, 16 Oct 2023 18:14:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902d38900b001c5fa48b9a0sm231465pld.33.2023.10.16.18.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 18:14:10 -0700 (PDT)
Message-ID: <be05643a-b75f-44c8-9dc2-35a914a51397@kernel.dk>
Date:   Mon, 16 Oct 2023 19:14:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with cancelable
 uring_cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20231009093324.957829-1-ming.lei@redhat.com>
 <ZS3LhEInXtaO+O1y@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZS3LhEInXtaO+O1y@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/23 5:47 PM, Ming Lei wrote:
> On Mon, Oct 09, 2023 at 05:33:15PM +0800, Ming Lei wrote:
>> Hello,
>>
>> Simplify ublk request & io command aborting handling with the new added
>> cancelable uring_cmd. With this change, the aborting logic becomes
>> simpler and more reliable, and it becomes easy to add new feature, such
>> as relaxing queue/ublk daemon association.
>>
>> Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
>> of blktests.
> 
> Hello Guys,
> 
> Ping...

I thought I had already queued this up... Done so now, thanks Ming.

-- 
Jens Axboe


