Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFFB145B62
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 19:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVSL1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 13:11:27 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35470 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVSL0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 13:11:26 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so228583iob.2
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 10:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jqXPtP0DSRmVKhqphPBt4y7dwJM01Y30wLczhsxzbME=;
        b=vukrzSTxKaE4XaoBk6bU3Nlf+smUPHMtGWeavBG3yJaXK87HmyYZj9WbWbALBk9NW8
         lIU1kY9DqAxUV6r5xWtTwfty9QP4n9qo/hQX9svNvg7uvl3wnjlecqGQYJrK4Y1jiwH9
         Hl9vWMOWM6bl7sUWhrECXRkieOL+RcB0FHk3PhDmpweUNbhhFioCK+fINwMr6D4kUUYP
         e9FSjZuBHfBrXLRyNtlCHpaPgi3cizhbvf/Mzw9ev6ROryeXq0fNqF9It0fS8LdwJUBn
         IKgxVXzdtZ+zguPv+m4m/E0DMHkAXC4MrlHe47pJEppBd0RPoUDeFaaoSl6bK/LxrQsF
         Gzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqXPtP0DSRmVKhqphPBt4y7dwJM01Y30wLczhsxzbME=;
        b=bHewfh+TfJtUWEAlRC1HH6WtKZigcpLQUenenpqWwaNToLDDtgMQXqBIcQeS168N9k
         JWJA8TVcZbAhzwC51IN7twT/m2i5+8aKnnQwqi2+lNbmnMoct3PmbO/sn9764jlupgCi
         kdCrVhKy9pIIjTfjNqV8FWfQo1Tv5olaWrQdmhgZiELBR8xWCYNmFppX9PUZeAgu84DY
         GRZLjG9sgayVtNBfmnS+MfBsHcVagoAtWQ3bUT3sXOuqij0Mlymz+myOU9lnejZ5XBLa
         NSI4x3CQYyVMwMvKtnPoSEH3Uu/KCi6ShFbWZUUxSKxFKZmZk8+9khc+HQoAwL0Ay3xy
         gFHg==
X-Gm-Message-State: APjAAAWneAiJC4TlEMeTBBLYx49bvtbEifu5yYAURLiXPTLiVBAl1a5Z
        A40sMhMi5EYJyuYV2oYZ9vKZPLC+3DM=
X-Google-Smtp-Source: APXvYqzlYzfSDltE9JTwlj7N+/Alss17UInp16VlGmtujj3bMuTfHv32U3EO3e9zORRLYeEIWfCunw==
X-Received: by 2002:a02:6055:: with SMTP id d21mr4698519jaf.21.1579716685670;
        Wed, 22 Jan 2020 10:11:25 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a6sm14598490iln.87.2020.01.22.10.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 10:11:24 -0800 (PST)
Subject: Re: First kernel version with uring sockets support
To:     Dmitry Sychov <dmitry.sychov@gmail.com>, io-uring@vger.kernel.org
References: <CADPKF+cOiZ9ydRVzpj1GN4amjzoyH1Y_NRA7PZ4CLPpb-FrYfQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a6ee3ab-6786-7fdd-05d4-a5ee9f078e6a@kernel.dk>
Date:   Wed, 22 Jan 2020 11:11:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CADPKF+cOiZ9ydRVzpj1GN4amjzoyH1Y_NRA7PZ4CLPpb-FrYfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/22/20 11:08 AM, Dmitry Sychov wrote:
> It's unclear starting from what version the kernel and headers
> were updated with sockets support(IORING_OP_ACCEPT etc).
> 
> I just checked today 2020/01/22 Focal Rossa Ubuntu and the last OP is
> only IORING_OP_TIMEOUT (still on kernel 5.4.0-12) ;(

Yeah, you'll need 5.5 for that.

> So maybe it's a good idea to comment-update every io_uring.h OP with
> minimum kernel version requirement...

You mean the one in liburing?

> p.s. Not every Linux user is a kernel hacker ;)

Definitely! This will be solved with 5.6 that introduces a probe
command, so you can query the running kernel for what opcodes it
supports. For now, it's not that easy, unfortunately...

-- 
Jens Axboe

