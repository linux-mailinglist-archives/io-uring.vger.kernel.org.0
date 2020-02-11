Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74841599AD
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 20:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgBKTYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 14:24:48 -0500
Received: from mail-il1-f179.google.com ([209.85.166.179]:39551 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbgBKTYs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 14:24:48 -0500
Received: by mail-il1-f179.google.com with SMTP id f70so4458644ill.6
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 11:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m351eyZJ30cAfqDaWiiVT3k/jxHcMwr9wePNI+f9z4A=;
        b=srfxRnRXcWe85gIWSmQcR2LqKH1JHSYL4MYbCxfZpLf6Y6+k9yj3aAO+7CoE7EKu/p
         Ih1KyAQAtQfqrJ12zRFDsaMp6m+IhLznr7mXzVtF1r2JuCiI8GEXtu1Qtva3MAETZccC
         Rndt7p6k5/N4L9XjMlQFGoklRnkbd2yEa95nopvX4c3J1kB0UD0KQioDldTb63dCkYDC
         cY9Xfzqs5G1YxsVeeSFCCZhzSAt58LySSOYqQ3wVglV3AMuoGPXgJVbhL7/+GaXMZuO0
         wGeRiVN+hpPbhZ0NXOjcSvfwW1B+DmMcnZezFOpI9PUchLjXye/CoB6vpQcGwJqKMBuA
         yYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m351eyZJ30cAfqDaWiiVT3k/jxHcMwr9wePNI+f9z4A=;
        b=okdAxblfAM2GS08WPQN+0P8JJg0htoES2rv29DaYwiW0QFZlmoxYsh4MquqjDzGVhp
         7pD/92Y26eI0v3lFylEntTJ2MfkbJ12wMQx2ertSC2R0nn3WmD8R6ycnYfH4LzUy0cAy
         EA5ZWudZG/5l5eFcrbSHqfk4APtNMo41IzxbUtIR9DFHGx2NoOxVOw2ZX6cXML/R+9sr
         sBXgaRRYen/joXzD5LSeCPCZZBj6zdVwN+pbZ9BN9IvK85FizpwQL4rJRwv2bIfOUN95
         UzT6HE58k22/p3ooekDE2wQ3uqfL9df7PVFL+5+B+iNH4GOAQ8gSazAMHRxKQUdKWc/1
         mylg==
X-Gm-Message-State: APjAAAWtkSWkWev6GVowgNV6ZVVoEs4Cf+fOGy/ddyxEIWHHV2/EVTUe
        aDRIROfIks/Anpd8Hoi69dgMaw5oito=
X-Google-Smtp-Source: APXvYqxzl+R8/grnRf6c2Sm1u9UMTfhO+Gg+4vb4m/1XS40jPPZqU+mozh7bJuvjqA4omWV0RFn3LA==
X-Received: by 2002:a92:5d88:: with SMTP id e8mr7989267ilg.106.1581449087351;
        Tue, 11 Feb 2020 11:24:47 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v63sm1573892ill.72.2020.02.11.11.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 11:24:46 -0800 (PST)
Subject: Re: Kernel BUG when registering the ring
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
 <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
 <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
 <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
 <CAD-J=zYfbtQaGy8KatprCPdzrKTg3sbHp6Vc2D8Y+mK2G08s4A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05f47cb5-8eec-1e1e-390e-b6215815e322@kernel.dk>
Date:   Tue, 11 Feb 2020 12:24:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYfbtQaGy8KatprCPdzrKTg3sbHp6Vc2D8Y+mK2G08s4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 12:23 PM, Glauber Costa wrote:
> Tested-by: Glauber Costa <glauber@scylladb.com>

Thanks!

-- 
Jens Axboe

