Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EF016621A
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBTQRZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:17:25 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:39013 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgBTQRZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:17:25 -0500
Received: by mail-pl1-f180.google.com with SMTP id g6so1731676plp.6
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 08:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aTvzlQ1bdP4PNCjnPVAMkaQoxvTBbjLsPvkTFe+LKb0=;
        b=nvWq+jMykZ+ChbWv2Fnkg274mMN6VE4t2QhYgTU2AgLZhEZx/h/wsZazAff0LvrNg3
         ka9zt+YCgyKA6kifcTiCTUxak3K8vA0AmmOAsftVf03k3JqrJS5EniUXYfju6leHAR+k
         o2QMGaGjpI4GJWxb2ABiGpMyVlgZyZzoKFXY0m9n5wKxBP+lYP2jOA9HBn18xa/uQNAn
         wpL2ZhsUbReFxvSbJ1eU9Kcg0HaK/8eBxQX6DEdquSmRa1mbU5Sqn15GGP/vVlreu1u5
         ATz+oc7Wn0YY01zMBW1cY1rxdw7DtM2Wij5qx//5CI02h3RYKZLb32vEUoXiFwsg77XU
         kBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aTvzlQ1bdP4PNCjnPVAMkaQoxvTBbjLsPvkTFe+LKb0=;
        b=UwNWJiCJC9yFicublTx4q1GEYhPECLUlmaG3DBMo0yGUoyraz230+I+adO29WRf21J
         2Pn5G1ry5DnHgRpisZxMyi1kF0RVC0e7XXDGufsjUw3y4TiOWrwUfXiPYjzACGcBtMe9
         byA7epkPZgg+VJnKNrfGmPCP02JHQcinRG81Wi0zNh49u1dDDUvtw47Yt8eNlcAMStYP
         p8TjV7U0xFQ30Ol9nyZpIkOKcw85cU/dfxNPywsZJoAe9vox2C7pJmvw8nmWreDn59Lg
         nR/pZKtnWr8XCipb7s0CJXhnittSopbgV5iFvPwO7cC02vUntldtO49Aj4lTV+cw5cuk
         S2GQ==
X-Gm-Message-State: APjAAAXndn1XtkGXJ+0tU7jyHSwUFEIhyYJn9h9a9e5QUxKfCuU/iRj8
        pvOvdUaPSnJwk8gICU6REcEY5g==
X-Google-Smtp-Source: APXvYqyJOuyJP9m3Og5/wB5332/pqM1tY9dTuG16GwPO8XFEFNmLLwCMczigNiJ+f6EQlZ3riCX+KQ==
X-Received: by 2002:a17:902:fe8d:: with SMTP id x13mr32697204plm.232.1582215444449;
        Thu, 20 Feb 2020 08:17:24 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id m15sm4240071pgn.40.2020.02.20.08.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:17:22 -0800 (PST)
Subject: Re: crash on connect
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
Date:   Thu, 20 Feb 2020 08:17:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 7:19 AM, Glauber Costa wrote:
> Hi there, me again
> 
> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> 
> This test is easier to explain: it essentially issues a connect and a
> shutdown right away.
> 
> It currently fails due to no fault of io_uring. But every now and then
> it crashes (you may have to run more than once to get it to crash)
> 
> Instructions are similar to my last test.
> Except the test to build is now "tests/unit/connect_test"
> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> 
> Run it with ./build/release/tests/unit/connect_test -- -c1
> --reactor-backend=uring
> 
> Backtrace attached

Perfect thanks, I'll take a look!


-- 
Jens Axboe

