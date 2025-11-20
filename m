Return-Path: <io-uring+bounces-10692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D50AAC73423
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 10:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9E6324E9CEF
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 09:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC71305065;
	Thu, 20 Nov 2025 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AB4Hlr77";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RLXnG1Za"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC21628689B;
	Thu, 20 Nov 2025 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763631617; cv=fail; b=hcOgKoCS5+mC5dkiWTA4jfp9p0yO+bn7hDGzpk2aFQ7atuY++kuAk9uJz7MdTMh+eRrYKtjE3vR+RGNKYz6k1bu4pSJAwjiAug2NUnli6ouqD6+nLMScUdisXAHpQVD4tHdhFIF5Nl9IaHxuID95th7jU9yrpkTn97MGZ0UhAQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763631617; c=relaxed/simple;
	bh=uF8hIycoC2zBUGLrsEuUQ0KoNk+VhW6ErwvhZaco9H4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hmMnqikVEJHm5MhvHCsuDllPBAFBrBFleZO89jAFUsbHwhLR4i6umd6EHs5u3Jg1Q8u4/2ycFd8F5JIf1z1dv3v0UCz/fCWqJGmJKQX2CM2usJjv+aJActPNVZhPRc57CMX0aTjq5TurDJYqhaNdw0PIlMHijcIR/kBnhRJ+0BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AB4Hlr77; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RLXnG1Za; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK8psgo025083;
	Thu, 20 Nov 2025 09:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x4fUEt2dY48v08qsyq
	D9z9bao7UeIcMWh+YtvJ7Wa8M=; b=AB4Hlr77en1zgu1iHk+B7Apaq3MqGGIEQ/
	LJPRtUuMhWhDPaxaVa8d9RCv2WkwtmQyQGbvbfSX/X3ZI5PCxribrfPwZ7SkYOUs
	Mm3w/pFzWHW5Q/uQeRg5PE4+PF61p0O+oehQ1HEg8yivz/khZDYd6Pni+35DcrzY
	v5/+F/xcFdHF8S7clbtEMJsAIwLTEdoCJItKirj5IPyiml/LWuK9XkY/qqsjxzjX
	lGZgmMQI9AXnc7WunZ1BATwjHe70ovuNtMP5ScOj0oE4I/4pelk/0zdCwg1fJ0bV
	IBATtE6JZk1Q6LKxrGOYdIsrKky4J+jqAXLaJ5JO7GginDhFr6XA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968raq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:39:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7gVgs003837;
	Thu, 20 Nov 2025 09:39:13 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012012.outbound.protection.outlook.com [52.101.48.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybt6cu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:39:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qumUVLD8P0uKYvJ7uVWudq9i4wKFIjLo5no4cipmWp7FgGDeMROJ9SLikEwdIXLQx3hYL8JWxIRO0+H6BY7R35oh1oyhUMYADamCGTilmDupeWH8oe9SOtk/JIrZiO+nEiMzsI+PC/7Z0RgL85ulIRioCi0/dN1Q1aEihQJg81pMT6SzPAfPZuvLzqgk/6BjBOQt1WnsEQSoD/Prlf9I0AjsAwUqDu//d3vRN2fNOouqkUnNmVzuJmHobEsSCl7DN8Dd4l36Utsq12doFC6kt6xo1FN1wFrn9SGVQB5iBKtECSmH2tzwUKqkvbtABelETM2nhoB5tfnbV/v8rayefQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4fUEt2dY48v08qsyqD9z9bao7UeIcMWh+YtvJ7Wa8M=;
 b=EPadCiow1JLm5mXLBKnooPPkY+Dv/TOCMNeKn9m7TdoA5SBor3HvaFzmsge5AZKNn919vjgcqiN2ZqtQgrSMRVGjFOdwGVxqQAZ/52ja1wYxk1Tsd6zXWsFjqma8ePfjVczzT8u3XFzAhYLvwP6egaLb5k5Y90IYroTqesKaUkXN5w+0TEeTtXL82RpGu4HCx6wIkGKLqnprLIC64NTbAum8ztFFuKy92nE0VzBb1LJhH+EHBO7RMcn3ZTQrFTVI1kDV84YPkaEYYsWjIrAkX3tDfK0TX0TY/i7beypYd4SqTNAV6EPpj7Qmf3Xe6J4yUgX1t8z6WELoUtfGK6mhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4fUEt2dY48v08qsyqD9z9bao7UeIcMWh+YtvJ7Wa8M=;
 b=RLXnG1Za6wMrmX2TAQBIw5BpkcE78ld/LLbOQrT5M5d/6AZjS6jh9rVYbibmI0/2G5qcqodlDWuEYuZpYc7vSqNUwligEryQt4aRN9akeKpIOGqe+X4GLYfDyWtFdyGQBXRLV8B8Bb8UIQVEzQLF9sQiA1sai0ycIgKt/k2fib8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFA043F25E4.namprd10.prod.outlook.com (2603:10b6:f:fc00::d39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 09:38:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:38:59 +0000
Date: Thu, 20 Nov 2025 09:38:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Shyti <andi.shyti@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        Christian Brauner <brauner@kernel.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@lst.de>, Daniel Borkmann <daniel@iogearbox.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, David Ahern <dsahern@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Zhou <dennis@kernel.org>, Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, John Allen <john.allen@amd.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Juergen Gross <jgross@suse.com>, Kees Cook <kees@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mika Westerberg <westeri@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Namhyung Kim <namhyung@kernel.org>,
        Neal Cardwell <ncardwell@google.com>, nic_swsd@realtek.com,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Olivia Mackall <olivia@selenic.com>, Paolo Abeni <pabeni@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Peter Huewe <peterhuewe@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Srinivas Kandagatla <srini@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>, x86@kernel.org,
        Yury Norov <yury.norov@gmail.com>, amd-gfx@lists.freedesktop.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-mm@kvack.org,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 00/44] Change a lot of min_t() that might mask high bits
Message-ID: <6ef2fb97-56a5-4cf1-9dc4-b46fa04cbdae@lucifer.local>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
X-ClientProxiedBy: LO0P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFA043F25E4:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b535ed-f831-4444-84b2-08de2818a215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c9/CcJ7O60eQP7KLrCZxQFr3Q8U8cBg+5mO4hB6PRYN1T3QIDxN2grHVLHw6?=
 =?us-ascii?Q?TKs4x3ONPpB5+jtTKf7Nw86mws2Z/yGNS9epYtS0h/Sa4zMJrOeE+8gG+gTk?=
 =?us-ascii?Q?X7MMFaMcSxnD2yQ91Jb/7e+lvUD3OHTA78ZuEb154amMdJrxxuHN5MfUSw3k?=
 =?us-ascii?Q?cRThLzGheaOk/8OyRerEdXw5YyaHgxTelJ/1IxAhFTzU3DpoSBBBh8iIr1im?=
 =?us-ascii?Q?0kq0p1wl+W6yxHWQy3ORLkrRdG4FPwIBbDdzCM/JPLopr8eP0ynpZ+zupbbk?=
 =?us-ascii?Q?KcX+Q/Koof/iVc1kgykBW3pN0ERkdCGalezZMG2ZtcUhpOv0TIv+BY9ifdJA?=
 =?us-ascii?Q?UQSVBHehFiHC+JKj5o+An4G6xWm1kvvsJChPE97KjDHFDol0S4pJnBSzSN9y?=
 =?us-ascii?Q?BBLDy2iiI757oepk8e0MVuTMeQXuz0aJuQyQIC89dRAemyhInQ+xDet5+mQu?=
 =?us-ascii?Q?hM8qv+A7A8HuZHwyApUTTU7uBN3WJJejKDnmD6CqJseHOpzgINLV1lpZHd3r?=
 =?us-ascii?Q?3BwzwMKSc1UnIEilqDMenIyZ1dYa9GIPY68bapQnnZXkiX4fdfic5cPrRLds?=
 =?us-ascii?Q?KOLIrV3KavsouaTCQtaELQjLSQTChUCFtxBPVitIcnWSuoWRmTDtMcHYth+g?=
 =?us-ascii?Q?Qu6fJ8ebIpAoqO4HhOkatNNmHcE4mV1ltApCBQ6qSvFsOvA1rY0JZM2ERsPw?=
 =?us-ascii?Q?gErnb9+gYt3p3YGP1tuAZ2J1oNJjmtyMW9KnbzavtI65FZS3UALs+FlkAHdg?=
 =?us-ascii?Q?OEXmD5Wxn6BBdQXx/lqVKFKoK0gxldZTNkMds24+zAqhEfDmk06ooRdvNraw?=
 =?us-ascii?Q?zSHDA/rGqiP6h+e37GZ4P7qnEZ14pty6bBqY7MOLVXqX6CW3Q/O+x4un5Xe1?=
 =?us-ascii?Q?cC7UYL8WkSba//fEBQAfsrAc1szn7ypZvjpjp07JOEjY9WTUyJYWeJsJbGLB?=
 =?us-ascii?Q?mBomKueBFkZf+hhHnsnRTlvMDwcL2aNh2MCIGKoWMYr7ev7bTZaa/3/jhOEu?=
 =?us-ascii?Q?gUEn8aDdNa0PiFu1oYAN/l3Zv8dj9JSHB+HA1TjKMyNBW48Wc2rcW0y0ZZb7?=
 =?us-ascii?Q?advIteVDFgdwYgsN3+2LZe0XyDoVEaOR+RmlZPY4xmRdkeCM1Wp8ey18lg/A?=
 =?us-ascii?Q?+A1qKGRsNOSvM8+sUsDHLwMNxoKL/cELW3ykuJ7rVr5mib3C65HCOqSU672P?=
 =?us-ascii?Q?Nv+V+WQj0EVMOmr1F3S2cVbLlGyntc/gyJJSSsr7Trm6Xtta6G1Y2sd3AVtb?=
 =?us-ascii?Q?2tkKMThSd4GkywWpuFdXkVYQfBAJGUXNzE7GiXxgSnfE1bUG5FNqjk+Oydy7?=
 =?us-ascii?Q?mcD/FNGceMjf0JSLVv2p9Poj0aG2KCk9pjcpmiX9Hwb3pJf4H99Rzl3l7eNG?=
 =?us-ascii?Q?0wntEwY8uGnW501P1N15JLtk19LGOTCCbRjrvX1KaijWSlGxCcJZFXjEGF/R?=
 =?us-ascii?Q?/kYy7l7qwImf/snQObrGrY181BRdOAYG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kPRWY1LIwS5S+D/L+x8VTm9PTXQwjo2HENrTSiBL4yuumMrLXTWwdbpU5r9W?=
 =?us-ascii?Q?mAkDtwRm/3YlQxL/4xhbbKlRCQbZ3YN5O1+hNdX0w+GbFqpmkztV2OK/rb8N?=
 =?us-ascii?Q?Y2aSRqdtiuBzTC4YnI3KMSvWJIM6146cw3wRVbStas3EG2rGlycuYpOnBlzD?=
 =?us-ascii?Q?agcHk/JxFwpyFQBnRQnDM0F27l6qaCghYvfZZwR4Jm7/26UQPbVAG4z8uz8Y?=
 =?us-ascii?Q?aCpsqMjbqE0jkplok//0MOC8WuvWijf+3o8G2b+SvKi5hja1ehhsoLjFrj+5?=
 =?us-ascii?Q?Wjdm51ZYTEKpUe+Ntir9dvafBLYsftdiZj4ytDlG9aOD2E7op2yOnMaEjZ0V?=
 =?us-ascii?Q?SjRSMp54wNvi2SRmla5MHdwc3reVek6AZBUETf6D0AHSIBIvrsP0DVrjekMY?=
 =?us-ascii?Q?s0z0ddbwPNYnvY1+2P9Fl9xO2GPyHsCRMEs/I7N9vCwxQb2TP/mlLlapd7I4?=
 =?us-ascii?Q?VRVEADyXrgDGTefu9DB5YSEKRAKpYjIT/ciWQydQkYHcs+KFhct4NKkvfViJ?=
 =?us-ascii?Q?4Qvfb9d1Z5VBPDMkn+I2tpE0FHgyiJmLSQBiRuCQrn4Yku7s8z0SwqVOhXkt?=
 =?us-ascii?Q?sjs48IOWIwwNoJs+c/PTJ2IJJp5wn8kOn7nmfbIcAHZ7dwTlQy6zCFtdOIdt?=
 =?us-ascii?Q?t3qYuTZpPvWpMZKt2oMDFtIakSQmy/dia0RPuBPFjiRFiv1MmYtz/uLyCVUV?=
 =?us-ascii?Q?qJ1P933vB6vRc2q9I7j3e6n5pEm5G7i3TOE7Cpd4fXGM2Js3r0XcrdqHJIjS?=
 =?us-ascii?Q?DtHDiiw/Gn655DDunBC7Cgtfnp11N5Ft8TPB8akL5UY9eABrzFrX6yLR10OC?=
 =?us-ascii?Q?Wx8Vhn1OZ8aHYi/swZEAIRCOPyUtWOwvRZn+jwn+cXnFF8/0z0FQ+6wq0MO6?=
 =?us-ascii?Q?dkCY197auRmY0l7h9/OMaVLOTeIIbIH8yRirwWdzayjaE24UeTDjbPxJjDO1?=
 =?us-ascii?Q?qlIHhI2qwHu4jH4cuQPxMsYl4VpX3OHEt2JfDTzPpZJ01FXrahsaDYtGSfud?=
 =?us-ascii?Q?a19fWW2NAL7kQUA6SMzwRNFdlM3uNDJkOyTtCmdPzOLy1vPBjtpop3rMUWfE?=
 =?us-ascii?Q?Q6N1XSY67waBy8146iAJFW6dND3eyb9guJY8b8Bzwp+sWNySrZERyF9t9DzV?=
 =?us-ascii?Q?K8MVFssjKHGbrx+vogdqTcTVFMGJ7XqMc36sO8H5FWY3bf0HZq2dDfafyhyf?=
 =?us-ascii?Q?tyTTG4Fe1bSaXBg70qUqN4TU1Od2A0R+chbpxQS3rBJ/q56J0LZbARFaCwc1?=
 =?us-ascii?Q?NoEUwObIcb/xt/Y3o4mQhMfVOeq8byLQ3hT8SAiF07n58Kx2B5yB7t5aUwFt?=
 =?us-ascii?Q?lyEpocmUmWK+OA7cX+KxrnLCNHjfIAEqqbnp4+rLPBdCRBoKf3c4gUG0iRun?=
 =?us-ascii?Q?nFNKH9Zu7hXkExmVF5VULFttq7mXoKrMWNSJMIQk6lTuujq4FKW43EA5Mbo3?=
 =?us-ascii?Q?Zfdm3MGQYarA55IjxUjCNDkOK+V6KL2sM3fwKAv01J8TuU0SwW0SV1+VlEtl?=
 =?us-ascii?Q?Q2ql1qNK49iz0m6jrBo4Q3zIyTbBma98snvo31b5AXg1BXWg1uCV1qR/1PzL?=
 =?us-ascii?Q?TN8K0SdxFBxk8ffmj0mqmzGEc46NFvfzWecQt8Fv3vrjkAh2qD7joo7UmEbr?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4mxMIwaVn/X497q5Wi5JUtAxmEf3wjrEIy4nzUFPT/jD42SftGbN4p5Rz70m+EYpEQEGs0Ube3/twWm/2YxPm0y9Rj+w/tHx5SCLNOrWrSAgu5PxK3EhAz68hADb9iyr15uLM04z+boMFb10tzH8KTL0m8PVx8/6ysNDCOLbVsk6+M0jL21n64SujDsSIrDnhnAD5BnY3rCg6OI/nKGLhuyTk3QXTrlCyokW1yvAkBU76PxRpPFxwIywnu5KRUgklBfmb/0Y3cAD2B5ejR9BHj6u0wERyx2PgoRnpi4WOBIXGEqxB8O3b0YEVk3UFk7JHWncl4qAvXIgLMDDXNGIGUvcpvFEcLh9iAz+VL72rSy0X5EfOwGNFYFaIndAmOnqsjD1dyOAgJJ6KOW12S1vwmwXDibM9GtHEA74ckN4Q7ZGxt3yzeHZiN6l7/wtYz25Sw1kDtwHyzH+Ya32rqGa/AtzrwzZW0CxLByYmt6AkzmfDnXXB8ljC1ef8z65/t55/k8eGurdtnDh86qOLtXr4CBZZAW02zh84yi+GU1OF+Dj2BkSEFkWCtYTgfKIqtnk8OljlnwBz0T1weEgkk883Tnb2atFRHMMuIpavc4dBD8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b535ed-f831-4444-84b2-08de2818a215
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:38:59.8734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ItduNliVtAqDKxYryyBeUrZMlHyQ5n8PkmB+iBXaQXZfE2lMdgCPgtX3mDnbFNa6n1HScfGbp2FCwJ2jr6nIo1m2TAzUmSBipCwRwAfUTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA043F25E4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=968
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511200058
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691ee1c1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Wzxjd0fUqIwO4rn60qQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vHyM1L6ZHbOR8-4PRZUdcGdHQ1UfesM4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX9uw9B2QCWmyu
 YM7K3vh3wz+R/ZYJ4uUoPPImvw9SUAIzKiQ7diBcQnKJh8dyimqs6Tf+RIZdZdq4NqykmuMiQ6/
 C9MCakf8ppETzIeiclvCorDztPdQDnqDA6qkIjRD3LxTTjLC89MwDnwfUeBXY6I1mWH4ew4dVDa
 f5mmOh6Ad+P07cCPaWf7NUXqrRganjVL+jmeUCiSE4Uj3ta2Oj4ztxh0PMhDyXVTVMNdi20thva
 xOfsYAUhK1jH4uJ2npIlStUAg3RjSKomM4JeA3JkUYfVLJSZdSVUHP6mFcvlcol86IX5zzClIRM
 u6MEgWxTuCQYBy0bSYu46I1T9c/iKNg8ZcDWf+4dgtvzViAGm7uNNg+5JOfHx22izInBQpJS0Bx
 A3CIo0+iB/qTd4yJ4nvbpbbO0HFAaA==
X-Proofpoint-ORIG-GUID: vHyM1L6ZHbOR8-4PRZUdcGdHQ1UfesM4

On Wed, Nov 19, 2025 at 10:40:56PM +0000, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
>
> It in not uncommon for code to use min_t(uint, a, b) when one of a or b
> is 64bit and can have a value that is larger than 2^32;
> This is particularly prevelant with:
> 	uint_var = min_t(uint, uint_var, uint64_expression);
>
> Casts to u8 and u16 are very likely to discard significant bits.
>
> These can be detected at compile time by changing min_t(), for example:
> #define CHECK_SIZE(fn, type, val) \
> 	BUILD_BUG_ON_MSG(sizeof (val) > sizeof (type) && \
> 		!statically_true(((val) >> 8 * (sizeof (type) - 1)) < 256), \
> 		fn "() significant bits of '" #val "' may be discarded")
>
> #define min_t(type, x, y) ({ \
> 	CHECK_SIZE("min_t", type, x); \
> 	CHECK_SIZE("min_t", type, y); \
> 	__cmp_once(min, type, x, y); })
>
> (and similar changes to max_t() and clamp_t().)

Have we made sure that the introduction of these don't cause a combinatorial
explosion like previous min()/max() changes did?

>
> This shows up some real bugs, some unlikely bugs and some false positives.
> In most cases both arguments are unsigned type (just different ones)
> and min_t() can just be replaced by min().
>
> The patches are all independant and are most of the ones needed to
> get the x86-64 kernel I build to compile.
> I've not tried building an allyesconfig or allmodconfig kernel.

Well I have a beefy box at my disposal so tried thiese for you :)

Both allyesconfig & allmodconfig works fine for x86-64 (I tried both for good
measure)

> I've also not included the patch to minmax.h itself.
>
> I've tried to put the patches that actually fix things first.
> The last one is 0009.
>
> I gave up on fixing sched/fair.c - it is too broken for a single patch!
> The patch for net/ipv4/tcp.c is also absent because do_tcp_getsockopt()
> needs multiple/larger changes to make it 'sane'.

I guess this isn't broken per se there just retain min_t()/max_t() right?

>
> I've had to trim the 124 maintainers/lists that get_maintainer.pl finds
> from 124 to under 100 to be able to send the cover letter.
> The individual patches only go to the addresses found for the associated files.
> That reduces the number of emails to a less unsane number.
>
> David Laight (44):
>   x86/asm/bitops: Change the return type of variable__ffs() to unsigned
>     int
>   ext4: Fix saturation of 64bit inode times for old filesystems
>   perf: Fix branch stack callchain limit
>   io_uring/net: Change some dubious min_t()
>   ipc/msg: Fix saturation of percpu counts in msgctl_info()
>   bpf: Verifier, remove some unusual uses of min_t() and max_t()
>   net/core/flow_dissector: Fix cap of __skb_flow_dissect() return value.
>   net: ethtool: Use min3() instead of nested min_t(u16,...)
>   ipv6: __ip6_append_data() don't abuse max_t() casts
>   x86/crypto: ctr_crypt() use min() instead of min_t()
>   arch/x96/kvm: use min() instead of min_t()
>   block: use min() instead of min_t()
>   drivers/acpi: use min() instead of min_t()
>   drivers/char/hw_random: use min3() instead of nested min_t()
>   drivers/char/tpm: use min() instead of min_t()
>   drivers/crypto/ccp: use min() instead of min_t()
>   drivers/cxl: use min() instead of min_t()
>   drivers/gpio: use min() instead of min_t()
>   drivers/gpu/drm/amd: use min() instead of min_t()
>   drivers/i2c/busses: use min() instead of min_t()
>   drivers/net/ethernet/realtek: use min() instead of min_t()
>   drivers/nvme: use min() instead of min_t()
>   arch/x86/mm: use min() instead of min_t()
>   drivers/nvmem: use min() instead of min_t()
>   drivers/pci: use min() instead of min_t()
>   drivers/scsi: use min() instead of min_t()
>   drivers/tty/vt: use umin() instead of min_t(u16, ...) for row/col
>     limits
>   drivers/usb/storage: use min() instead of min_t()
>   drivers/xen: use min() instead of min_t()
>   fs: use min() or umin() instead of min_t()
>   block: bvec.h: use min() instead of min_t()
>   nodemask: use min() instead of min_t()
>   ipc: use min() instead of min_t()
>   bpf: use min() instead of min_t()
>   bpf_trace: use min() instead of min_t()
>   lib/bucket_locks: use min() instead of min_t()
>   lib/crypto/mpi: use min() instead of min_t()
>   lib/dynamic_queue_limits: use max() instead of max_t()
>   mm: use min() instead of min_t()
>   net: Don't pass bitfields to max_t()
>   net/core: Change loop conditions so min() can be used
>   net: use min() instead of min_t()
>   net/netlink: Use umin() to avoid min_t(int, ...) discarding high bits
>   net/mptcp: Change some dubious min_t(int, ...) to min()
>
>  arch/x86/crypto/aesni-intel_glue.c            |  3 +-
>  arch/x86/include/asm/bitops.h                 | 18 +++++-------
>  arch/x86/kvm/emulate.c                        |  3 +-
>  arch/x86/kvm/lapic.c                          |  2 +-
>  arch/x86/kvm/mmu/mmu.c                        |  2 +-
>  arch/x86/mm/pat/set_memory.c                  | 12 ++++----
>  block/blk-iocost.c                            |  6 ++--
>  block/blk-settings.c                          |  2 +-
>  block/partitions/efi.c                        |  3 +-
>  drivers/acpi/property.c                       |  2 +-
>  drivers/char/hw_random/core.c                 |  2 +-
>  drivers/char/tpm/tpm1-cmd.c                   |  2 +-
>  drivers/char/tpm/tpm_tis_core.c               |  4 +--
>  drivers/crypto/ccp/ccp-dev.c                  |  2 +-
>  drivers/cxl/core/mbox.c                       |  2 +-
>  drivers/gpio/gpiolib-acpi-core.c              |  2 +-
>  .../gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c  |  4 +--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        |  2 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
>  drivers/i2c/busses/i2c-designware-master.c    |  2 +-
>  drivers/net/ethernet/realtek/r8169_main.c     |  3 +-
>  drivers/nvme/host/pci.c                       |  3 +-
>  drivers/nvme/host/zns.c                       |  3 +-
>  drivers/nvmem/core.c                          |  2 +-
>  drivers/pci/probe.c                           |  3 +-
>  drivers/scsi/hosts.c                          |  2 +-
>  drivers/tty/vt/selection.c                    |  9 +++---
>  drivers/usb/storage/protocol.c                |  3 +-
>  drivers/xen/grant-table.c                     |  2 +-
>  fs/buffer.c                                   |  2 +-
>  fs/exec.c                                     |  2 +-
>  fs/ext4/ext4.h                                |  2 +-
>  fs/ext4/mballoc.c                             |  3 +-
>  fs/ext4/resize.c                              |  2 +-
>  fs/ext4/super.c                               |  2 +-
>  fs/fat/dir.c                                  |  4 +--
>  fs/fat/file.c                                 |  3 +-
>  fs/fuse/dev.c                                 |  2 +-
>  fs/fuse/file.c                                |  8 ++---
>  fs/splice.c                                   |  2 +-
>  include/linux/bvec.h                          |  3 +-
>  include/linux/nodemask.h                      |  9 +++---
>  include/linux/perf_event.h                    |  2 +-
>  include/net/tcp_ecn.h                         |  5 ++--
>  io_uring/net.c                                |  6 ++--
>  ipc/mqueue.c                                  |  4 +--
>  ipc/msg.c                                     |  6 ++--
>  kernel/bpf/core.c                             |  4 +--
>  kernel/bpf/log.c                              |  2 +-
>  kernel/bpf/verifier.c                         | 29 +++++++------------
>  kernel/trace/bpf_trace.c                      |  2 +-
>  lib/bucket_locks.c                            |  2 +-
>  lib/crypto/mpi/mpicoder.c                     |  2 +-
>  lib/dynamic_queue_limits.c                    |  2 +-
>  mm/gup.c                                      |  4 +--
>  mm/memblock.c                                 |  2 +-
>  mm/memory.c                                   |  2 +-
>  mm/percpu.c                                   |  2 +-
>  mm/truncate.c                                 |  3 +-
>  mm/vmscan.c                                   |  2 +-
>  net/core/datagram.c                           |  6 ++--
>  net/core/flow_dissector.c                     |  7 ++---
>  net/core/net-sysfs.c                          |  3 +-
>  net/core/skmsg.c                              |  4 +--
>  net/ethtool/cmis_cdb.c                        |  7 ++---
>  net/ipv4/fib_trie.c                           |  2 +-
>  net/ipv4/tcp_input.c                          |  4 +--
>  net/ipv4/tcp_output.c                         |  5 ++--
>  net/ipv4/tcp_timer.c                          |  4 +--
>  net/ipv6/addrconf.c                           |  8 ++---
>  net/ipv6/ip6_output.c                         |  7 +++--
>  net/ipv6/ndisc.c                              |  5 ++--
>  net/mptcp/protocol.c                          |  8 ++---
>  net/netlink/genetlink.c                       |  9 +++---
>  net/packet/af_packet.c                        |  2 +-
>  net/unix/af_unix.c                            |  4 +--
>  76 files changed, 141 insertions(+), 176 deletions(-)
>
> --
> 2.39.5
>

