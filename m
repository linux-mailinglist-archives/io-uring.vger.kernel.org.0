Return-Path: <io-uring+bounces-11610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8311D19EB9
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 16:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 93AFB3013324
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 15:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6244306487;
	Tue, 13 Jan 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VF9TO2j2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D442F5A3D;
	Tue, 13 Jan 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318279; cv=none; b=usf5Fom+cl0mK9m1n8VsWJSecygW/b5SLlg/+jrpKWU0Ngn11lwW16PQXkTiaPIRgpLoXC9y/foDAt3f1k40qnAu949bbyrMSNBrtCHqhInfoddy1CpMFuInVSoMGFJZLK2fxJ3q8aDU3fy79FxfvvUB0dA2u3xXeOz2Uk8aUek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318279; c=relaxed/simple;
	bh=BrfgoSonMvRUcG/kiI34pQUml3tPz+JNEMcsTM3m9JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuGg+RCTExCx+PiQYjH33uoqDi9IzGL6epyKuyYlnyd7eAV5a7wJaAJvkyCuEuwaqnPztW7MC0pyQ3kLHLfgIy4W3qN+LUAVRwZQuOXKzKo3Yu5RMA59bDnc5MOHgAFlVfXU8aPqyUFLTJeXSYUaqnOAjZ1PqMNy+RxGwxOsyjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VF9TO2j2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6AAC19424;
	Tue, 13 Jan 2026 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318279;
	bh=BrfgoSonMvRUcG/kiI34pQUml3tPz+JNEMcsTM3m9JY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VF9TO2j2KC8RsxGvUfnFEY7JP4t+7UmvRyGAFYR+CE49pKi7PKRvjpGdc5O+SbCHa
	 BDt+iM6n8BdzpY8iJmizxaEoNtMTHmr16q4ri2cdLur++ZYBYAz/2eHe2D8iuLbrb1
	 Q5dz8EAp2XevoT2fc2FJX3TbilYOiLt6rgu3y3ciFkOcZc7fryM/8GibpOUIY4Ev58
	 S7SXJl+yPq4cw3Nme8Eu+aPAxDoxkX78f4B7Zj4nGOa447jQeZAYk/EbD9bvMSWXLp
	 xBdOiX88b5Y8oO8/molcBXgrlcs2SsEuefEOjo490+u3GefDnKqbVHVuKXls7KdJDi
	 zSJ/LyCUUU50Q==
Date: Tue, 13 Jan 2026 15:31:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/59] struct filename: saner handling of long names
Message-ID: <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
 <20260108073803.425343-16-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h6/Gi/PuZHhd8q9O"
Content-Disposition: inline
In-Reply-To: <20260108073803.425343-16-viro@zeniv.linux.org.uk>
X-Cookie: Spelling is a lossed art.


--h6/Gi/PuZHhd8q9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2026 at 07:37:19AM +0000, Al Viro wrote:
> Always allocate struct filename from names_cachep, long name or short;
> short names would be embedded into struct filename.  Longer ones do
> not cannibalize the original struct filename - put them into kmalloc'ed
> buffers (PATH_MAX-sized for import from userland, strlen() + 1 - for
> ones originating kernel-side, where we know the length beforehand).

I'm seeing a regression in -next in the execveat kselftest which bisects
to 2a0db5f7653b ("struct filename: saner handling of long names").  The
test triggers two new failures with very long filenames for tests that
previously succeeded:

# # Failed to open length 4094 filename, errno=3D36 (File name too long)
# # Invoke exec via root_dfd and relative filename
# # child execveat() failed, rc=3D-1 errno=3D36 (File name too long)
# # child 9501 exited with 36 neither 99 nor 99
# not ok 48 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyy=
yyyyyyyyyy', 0)...=20
# # Failed to open length 4094 filename, errno=3D36 (File name too long)
# # Invoke script via root_dfd and relative filename
# # child execveat() failed, rc=3D-1 errno=3D36 (File name too long)
# # child 9502 exited with 36 neither 127 nor 126
# not ok 49 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyy=
yyyyyyyyyy', 0)...=20

full log:

   https://lava.sirena.org.uk/scheduler/job/2367409#L9827

bisect log with links to logs from other test runs:

# bad: [0f853ca2a798ead9d24d39cad99b0966815c582a] Add linux-next specific f=
iles for 20260113
# good: [9843d35ffaf3ffbc0e0a05cd36107fe6081e948e] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [77157cb45c66bd652a08a360693fcced558c5ef9] ASoC: codecs: rt1320-sdw=
: convert to snd_soc_dapm_xxx()
# good: [8d38423d9dea7353a8a54a3ab2e0d0aa04ed34d0] regulator: core: don't f=
ail regulator_register() with missing required supply
# good: [b6376dbed8e173f9571583b5d358b08ff394e864] spi: Simplify devm_spi_*=
_controller()
# good: [0cd9bf6a6d9a1861087236cc5c275b3bea83cfdd] ASoC: codecs: da7213: Mo=
ve comma operator at the end of the line
# good: [22a4776a9ce50aa47f602d28f53ba9d613a38f49] ASoC: codecs: es8375: re=
move unnecessary format check
# good: [75d208bddcca55ec31481420fbb4d6c9703ba195] spi: stm32: avoid __mayb=
e_unused and use pm_ptr
# good: [04b61513dfe40f80f0dcc795003637b510522b3c] ASoC: SDCA: Replace use =
of system_wq with system_dfl_wq
# good: [9bf0bd7bdea6c402007ffb784dd0c0f704aa2310] ASoC: nau8821: Sort #inc=
lude directives
# good: [96d337436fe0921177a6090aeb5bb214753654fc] spi: dt-bindings: at91: =
add microchip,lan9691-spi
# good: [211243b69533e968cc6f0259fb80ffee02fbe0ca] firmware: cs_dsp: test_b=
in: Add tests for offsets > 0xffff
# good: [52ddc0106c77ff0eacf07b309833ae6e6a4e8587] ASoC: es8328: Remove dup=
licate DAPM routes
# good: [4c5e6d5b31bc623d89185d551681ab91cfd037c9] ASoC: codecs: ES8389: Up=
date clock configuration
# good: [420739112e95c9bb286b4e87875706925970abd3] ASoC: rt5575: Add the co=
dec driver for the ALC5575
# good: [284853affe73fe1ca9786bd52b934eb9d420a942] ASoC: rt1320: fix size_t=
 format string
# good: [25abdc151a448a17d500ea9468ce32582c479faa] ASoC: rt1320: fix the re=
mainder calculation of r0 value
# good: [0f698d742f628d02ab2a222f8cf5f793443865d0] spi: bcm63xx-hsspi: add =
support for 1-2-2 read ops
# good: [45e9066f3a487e9e26b842644364d045af054775] ASoC: Intel: avs: replac=
e strcmp with sysfs_streq
# good: [8db50f0fa43efe8799fd40b872dcdd39a90d7549] ASoC: rt1320: fix the wa=
rning the string may be truncated
# good: [c6bca73d699cfe00d3419566fdb2a45e112f44b0] ASoC: rt1320: Fix retry =
checking in rt1320_rae_load()
# good: [4ab48cc63e15cb619d641d1edf9a15a0a98875b2] ASoC: qcom: audioreach: =
Constify function arguments
# good: [99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd] ASoC: SDCA: Add ASoC jac=
k hookup in class driver
# good: [b0655377aa5a410df02d89170c20141a1a5bbc28] rust: regulator: replace=
 `kernel::c_str!` with C-Strings
# good: [32a708ba5db50cf928a1f1b2039ceef33de2c286] regulator: Add rt8092 su=
pport
# good: [a2a631830deb382a3d27b6f52b2d654a3e6bb427] ASoC: qcom: Constify APR=
/GPR result structs
# good: [7a8447fc71a09000cee5a2372b6efde45735d2c8] ASoC: codecs: wcd939x-sd=
w: use devres for regmap allocation
# good: [b39ef93a2e5b5f4289a3486d8a94a09a1e6a4c67] spi: stm32: perform smal=
l transfer in polling mode
# good: [3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c] ASoC: codec: rt286: Use =
devm_request_threaded_irq to manage IRQ lifetime and fix smatch warning
# good: [2a28b5240f2b328495c6565d277f438dbc583d61] ASoC: SOF: ipc4-control:=
 Add support for generic bytes control
# good: [1303c2903889b01d581083ed92e439e7544dd3e5] MAINTAINERS: Add MAINTAI=
NERS entry for the ATCSPI200 SPI controller driver
# good: [9a6bc0a406608e2520f18d996483c9d2e4a9fb27] ASoC: codecs: ES8326: Ad=
d kcontrol for DRE
# good: [29c8c00d9f9db5fb659b6f05f9e8964afc13f3e2] spi: add driver for NXP =
XSPI controller
# good: [7f7b350e4a65446f5d52ea8ae99e12eac8a972db] spi: stm32-qspi: Remove =
unneeded semicolon
# good: [02e7af5b6423d2dbf82f852572f2fa8c00aafb19] ASoC: Intel: sof_rt5682:=
 add tas2563 speaker amp support
# good: [f764645cb85a8b8f58067289cdfed28f6c1cdf49] ASoC: codecs: tas2780: t=
idyup format check in tas2780_set_fmt()
# good: [f4acea9eef704607d1a950909ce3a52a770d6be2] spi: dt-bindings: st,stm=
32-spi: add 'power-domains' property
# good: [f25c7d709b93602ee9a08eba522808a18e1f5d56] ASoC: SOF: Intel: pci-nv=
l: Set on_demand_dsp_boot for NVL-S
# good: [524ee559948d8d079b13466e70fa741f909699c0] ASoC: SOF: Intel: hda: O=
nly check SSP MCLK mask in case of IPC3
# good: [aa30193af8873b3ccfd70a4275336ab6cbd4e5e6] ASoC: Intel: catpt: Drop=
 superfluous space in PCM code
# good: [e39011184f23de3d04ca8e80b4df76c9047b4026] ASoC: SDCA: functions: F=
ix confusing cleanup.h syntax
# good: [03d281f384768610bf90697bce9e35d3d596de77] rust: regulator: add __r=
ust_helper to helpers
# good: [ba9b28652c75b07383e267328f1759195d5430f7] spi: imx: enable DMA mod=
e for target operation
# good: [9e92c559d49d6fb903af17a31a469aac51b1766d] regulator: max77675: Add=
 MAX77675 regulator driver
# good: [81acbdc51bbbec822a1525481f2f70677c47aee0] ASoC: sdw-mockup: Drop d=
ummy remove function
# good: [b884e34994ca41f7b7819f3c41b78ff494787b27] spi: spi-fsl-lpspi: conv=
ert min_t() to simple min()
# good: [fa08b566860bca8ebf9300090b85174c34de7ca5] spi: rzv2h-rspi: add sup=
port for DMA mode
# good: [0bb160c92ad400c692984763996b758458adea17] ASoC: qcom: Minor readab=
ility improve with new lines
# good: [fee876b2ec75dcc18fdea154eae1f5bf14d82659] spi: stm32-qspi: Simplif=
y SMIE interrupt test
# good: [124f6155f3d97b0e33f178c10a5138a42c8fd207] ASoC: renesas: rz-ssi: A=
dd support for 32 bits sample width
git bisect start '0f853ca2a798ead9d24d39cad99b0966815c582a' '9843d35ffaf3ff=
bc0e0a05cd36107fe6081e948e' '77157cb45c66bd652a08a360693fcced558c5ef9' '8d3=
8423d9dea7353a8a54a3ab2e0d0aa04ed34d0' 'b6376dbed8e173f9571583b5d358b08ff39=
4e864' '0cd9bf6a6d9a1861087236cc5c275b3bea83cfdd' '22a4776a9ce50aa47f602d28=
f53ba9d613a38f49' '75d208bddcca55ec31481420fbb4d6c9703ba195' '04b61513dfe40=
f80f0dcc795003637b510522b3c' '9bf0bd7bdea6c402007ffb784dd0c0f704aa2310' '96=
d337436fe0921177a6090aeb5bb214753654fc' '211243b69533e968cc6f0259fb80ffee02=
fbe0ca' '52ddc0106c77ff0eacf07b309833ae6e6a4e8587' '4c5e6d5b31bc623d89185d5=
51681ab91cfd037c9' '420739112e95c9bb286b4e87875706925970abd3' '284853affe73=
fe1ca9786bd52b934eb9d420a942' '25abdc151a448a17d500ea9468ce32582c479faa' '0=
f698d742f628d02ab2a222f8cf5f793443865d0' '45e9066f3a487e9e26b842644364d045a=
f054775' '8db50f0fa43efe8799fd40b872dcdd39a90d7549' 'c6bca73d699cfe00d34195=
66fdb2a45e112f44b0' '4ab48cc63e15cb619d641d1edf9a15a0a98875b2' '99a3ef1e81c=
d1775bc1f8cc2ad188b1fc755d5cd' 'b0655377aa5a410df02d89170c20141a1a5bbc28' '=
32a708ba5db50cf928a1f1b2039ceef33de2c286' 'a2a631830deb382a3d27b6f52b2d654a=
3e6bb427' '7a8447fc71a09000cee5a2372b6efde45735d2c8' 'b39ef93a2e5b5f4289a34=
86d8a94a09a1e6a4c67' '3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c' '2a28b5240f=
2b328495c6565d277f438dbc583d61' '1303c2903889b01d581083ed92e439e7544dd3e5' =
'9a6bc0a406608e2520f18d996483c9d2e4a9fb27' '29c8c00d9f9db5fb659b6f05f9e8964=
afc13f3e2' '7f7b350e4a65446f5d52ea8ae99e12eac8a972db' '02e7af5b6423d2dbf82f=
852572f2fa8c00aafb19' 'f764645cb85a8b8f58067289cdfed28f6c1cdf49' 'f4acea9ee=
f704607d1a950909ce3a52a770d6be2' 'f25c7d709b93602ee9a08eba522808a18e1f5d56'=
 '524ee559948d8d079b13466e70fa741f909699c0' 'aa30193af8873b3ccfd70a4275336a=
b6cbd4e5e6' 'e39011184f23de3d04ca8e80b4df76c9047b4026' '03d281f384768610bf9=
0697bce9e35d3d596de77' 'ba9b28652c75b07383e267328f1759195d5430f7' '9e92c559=
d49d6fb903af17a31a469aac51b1766d' '81acbdc51bbbec822a1525481f2f70677c47aee0=
' 'b884e34994ca41f7b7819f3c41b78ff494787b27' 'fa08b566860bca8ebf9300090b851=
74c34de7ca5' '0bb160c92ad400c692984763996b758458adea17' 'fee876b2ec75dcc18f=
dea154eae1f5bf14d82659' '124f6155f3d97b0e33f178c10a5138a42c8fd207'
# test job: [77157cb45c66bd652a08a360693fcced558c5ef9] https://lava.sirena.=
org.uk/scheduler/job/2363772
# test job: [8d38423d9dea7353a8a54a3ab2e0d0aa04ed34d0] https://lava.sirena.=
org.uk/scheduler/job/2354346
# test job: [b6376dbed8e173f9571583b5d358b08ff394e864] https://lava.sirena.=
org.uk/scheduler/job/2349564
# test job: [0cd9bf6a6d9a1861087236cc5c275b3bea83cfdd] https://lava.sirena.=
org.uk/scheduler/job/2348760
# test job: [22a4776a9ce50aa47f602d28f53ba9d613a38f49] https://lava.sirena.=
org.uk/scheduler/job/2344104
# test job: [75d208bddcca55ec31481420fbb4d6c9703ba195] https://lava.sirena.=
org.uk/scheduler/job/2337439
# test job: [04b61513dfe40f80f0dcc795003637b510522b3c] https://lava.sirena.=
org.uk/scheduler/job/2337708
# test job: [9bf0bd7bdea6c402007ffb784dd0c0f704aa2310] https://lava.sirena.=
org.uk/scheduler/job/2331106
# test job: [96d337436fe0921177a6090aeb5bb214753654fc] https://lava.sirena.=
org.uk/scheduler/job/2330456
# test job: [211243b69533e968cc6f0259fb80ffee02fbe0ca] https://lava.sirena.=
org.uk/scheduler/job/2330728
# test job: [52ddc0106c77ff0eacf07b309833ae6e6a4e8587] https://lava.sirena.=
org.uk/scheduler/job/2331457
# test job: [4c5e6d5b31bc623d89185d551681ab91cfd037c9] https://lava.sirena.=
org.uk/scheduler/job/2331902
# test job: [420739112e95c9bb286b4e87875706925970abd3] https://lava.sirena.=
org.uk/scheduler/job/2331721
# test job: [284853affe73fe1ca9786bd52b934eb9d420a942] https://lava.sirena.=
org.uk/scheduler/job/2298053
# test job: [25abdc151a448a17d500ea9468ce32582c479faa] https://lava.sirena.=
org.uk/scheduler/job/2307389
# test job: [0f698d742f628d02ab2a222f8cf5f793443865d0] https://lava.sirena.=
org.uk/scheduler/job/2295213
# test job: [45e9066f3a487e9e26b842644364d045af054775] https://lava.sirena.=
org.uk/scheduler/job/2295673
# test job: [8db50f0fa43efe8799fd40b872dcdd39a90d7549] https://lava.sirena.=
org.uk/scheduler/job/2292101
# test job: [c6bca73d699cfe00d3419566fdb2a45e112f44b0] https://lava.sirena.=
org.uk/scheduler/job/2290170
# test job: [4ab48cc63e15cb619d641d1edf9a15a0a98875b2] https://lava.sirena.=
org.uk/scheduler/job/2290906
# test job: [99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd] https://lava.sirena.=
org.uk/scheduler/job/2290884
# test job: [b0655377aa5a410df02d89170c20141a1a5bbc28] https://lava.sirena.=
org.uk/scheduler/job/2291654
# test job: [32a708ba5db50cf928a1f1b2039ceef33de2c286] https://lava.sirena.=
org.uk/scheduler/job/2279424
# test job: [a2a631830deb382a3d27b6f52b2d654a3e6bb427] https://lava.sirena.=
org.uk/scheduler/job/2281855
# test job: [7a8447fc71a09000cee5a2372b6efde45735d2c8] https://lava.sirena.=
org.uk/scheduler/job/2271765
# test job: [b39ef93a2e5b5f4289a3486d8a94a09a1e6a4c67] https://lava.sirena.=
org.uk/scheduler/job/2269645
# test job: [3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c] https://lava.sirena.=
org.uk/scheduler/job/2268634
# test job: [2a28b5240f2b328495c6565d277f438dbc583d61] https://lava.sirena.=
org.uk/scheduler/job/2266207
# test job: [1303c2903889b01d581083ed92e439e7544dd3e5] https://lava.sirena.=
org.uk/scheduler/job/2263475
# test job: [9a6bc0a406608e2520f18d996483c9d2e4a9fb27] https://lava.sirena.=
org.uk/scheduler/job/2264400
# test job: [29c8c00d9f9db5fb659b6f05f9e8964afc13f3e2] https://lava.sirena.=
org.uk/scheduler/job/2263994
# test job: [7f7b350e4a65446f5d52ea8ae99e12eac8a972db] https://lava.sirena.=
org.uk/scheduler/job/2268219
# test job: [02e7af5b6423d2dbf82f852572f2fa8c00aafb19] https://lava.sirena.=
org.uk/scheduler/job/2262640
# test job: [f764645cb85a8b8f58067289cdfed28f6c1cdf49] https://lava.sirena.=
org.uk/scheduler/job/2264492
# test job: [f4acea9eef704607d1a950909ce3a52a770d6be2] https://lava.sirena.=
org.uk/scheduler/job/2243888
# test job: [f25c7d709b93602ee9a08eba522808a18e1f5d56] https://lava.sirena.=
org.uk/scheduler/job/2244120
# test job: [524ee559948d8d079b13466e70fa741f909699c0] https://lava.sirena.=
org.uk/scheduler/job/2243989
# test job: [aa30193af8873b3ccfd70a4275336ab6cbd4e5e6] https://lava.sirena.=
org.uk/scheduler/job/2232727
# test job: [e39011184f23de3d04ca8e80b4df76c9047b4026] https://lava.sirena.=
org.uk/scheduler/job/2232430
# test job: [03d281f384768610bf90697bce9e35d3d596de77] https://lava.sirena.=
org.uk/scheduler/job/2231119
# test job: [ba9b28652c75b07383e267328f1759195d5430f7] https://lava.sirena.=
org.uk/scheduler/job/2231400
# test job: [9e92c559d49d6fb903af17a31a469aac51b1766d] https://lava.sirena.=
org.uk/scheduler/job/2232511
# test job: [81acbdc51bbbec822a1525481f2f70677c47aee0] https://lava.sirena.=
org.uk/scheduler/job/2232850
# test job: [b884e34994ca41f7b7819f3c41b78ff494787b27] https://lava.sirena.=
org.uk/scheduler/job/2232571
# test job: [fa08b566860bca8ebf9300090b85174c34de7ca5] https://lava.sirena.=
org.uk/scheduler/job/2232948
# test job: [0bb160c92ad400c692984763996b758458adea17] https://lava.sirena.=
org.uk/scheduler/job/2233041
# test job: [fee876b2ec75dcc18fdea154eae1f5bf14d82659] https://lava.sirena.=
org.uk/scheduler/job/2231262
# test job: [124f6155f3d97b0e33f178c10a5138a42c8fd207] https://lava.sirena.=
org.uk/scheduler/job/2232864
# test job: [0f853ca2a798ead9d24d39cad99b0966815c582a] https://lava.sirena.=
org.uk/scheduler/job/2367409
# bad: [0f853ca2a798ead9d24d39cad99b0966815c582a] Add linux-next specific f=
iles for 20260113
git bisect bad 0f853ca2a798ead9d24d39cad99b0966815c582a
# test job: [80f60a6b0c1e21da3f74ede4c74aa3f38efa31d5] https://lava.sirena.=
org.uk/scheduler/job/2367513
# bad: [80f60a6b0c1e21da3f74ede4c74aa3f38efa31d5] Merge branch 'libcrypto-n=
ext' of https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
git bisect bad 80f60a6b0c1e21da3f74ede4c74aa3f38efa31d5
# test job: [a0be739e9567908ff7b1b5efcc1c6b1f9e55a544] https://lava.sirena.=
org.uk/scheduler/job/2367625
# good: [a0be739e9567908ff7b1b5efcc1c6b1f9e55a544] Merge branch 'next' of h=
ttps://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git
git bisect good a0be739e9567908ff7b1b5efcc1c6b1f9e55a544
# test job: [50557224aa7b79cd076b9bb017a8b30e6b879b3f] https://lava.sirena.=
org.uk/scheduler/job/2367737
# bad: [50557224aa7b79cd076b9bb017a8b30e6b879b3f] Merge branch 'docs-next' =
of git://git.lwn.net/linux.git
git bisect bad 50557224aa7b79cd076b9bb017a8b30e6b879b3f
# test job: [7ff8a8def75f2b640b88af58a4b12a4882374ce8] https://lava.sirena.=
org.uk/scheduler/job/2367846
# good: [7ff8a8def75f2b640b88af58a4b12a4882374ce8] Merge branch 'vfs.all' o=
f https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
git bisect good 7ff8a8def75f2b640b88af58a4b12a4882374ce8
# test job: [19513ff202450d2ccc5fdbb202450af78ac21006] https://lava.sirena.=
org.uk/scheduler/job/2367991
# bad: [19513ff202450d2ccc5fdbb202450af78ac21006] Merge branch 'next' of ht=
tps://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
git bisect bad 19513ff202450d2ccc5fdbb202450af78ac21006
# test job: [3b4263ecddfdcf6c32339ede719b5071159e56ef] https://lava.sirena.=
org.uk/scheduler/job/2368112
# good: [3b4263ecddfdcf6c32339ede719b5071159e56ef] Merge branch 'pci/contro=
ller/misc'
git bisect good 3b4263ecddfdcf6c32339ede719b5071159e56ef
# test job: [732d43b6978db54024283dcd013e17064003f0d9] https://lava.sirena.=
org.uk/scheduler/job/2368208
# bad: [732d43b6978db54024283dcd013e17064003f0d9] do_sys_truncate(): switch=
 to CLASS(filename)
git bisect bad 732d43b6978db54024283dcd013e17064003f0d9
# test job: [46c4e9f4ebbddda1f4c37355dafcd4f10400a4ca] https://lava.sirena.=
org.uk/scheduler/job/2368283
# bad: [46c4e9f4ebbddda1f4c37355dafcd4f10400a4ca] file_getattr(): filename_=
lookup() accepts ERR_PTR() as filename
git bisect bad 46c4e9f4ebbddda1f4c37355dafcd4f10400a4ca
# test job: [2e0ee29dc2414f63503b79968a5081d8bffe00d2] https://lava.sirena.=
org.uk/scheduler/job/2368364
# good: [2e0ee29dc2414f63503b79968a5081d8bffe00d2] get rid of audit_reusena=
me()
git bisect good 2e0ee29dc2414f63503b79968a5081d8bffe00d2
# test job: [2a0db5f7653b3576c430f8821654f365aaa7f178] https://lava.sirena.=
org.uk/scheduler/job/2368516
# bad: [2a0db5f7653b3576c430f8821654f365aaa7f178] struct filename: saner ha=
ndling of long names
git bisect bad 2a0db5f7653b3576c430f8821654f365aaa7f178
# test job: [9700b822564a7f22137f3017951b1540b98d0278] https://lava.sirena.=
org.uk/scheduler/job/2368899
# good: [9700b822564a7f22137f3017951b1540b98d0278] getname_flags() massage,=
 part 1
git bisect good 9700b822564a7f22137f3017951b1540b98d0278
# test job: [25d18822f3d92a78f38a4fb32c8ff1d9a28f6072] https://lava.sirena.=
org.uk/scheduler/job/2369056
# good: [25d18822f3d92a78f38a4fb32c8ff1d9a28f6072] struct filename: use nam=
es_cachep only for getname() and friends
git bisect good 25d18822f3d92a78f38a4fb32c8ff1d9a28f6072
# first bad commit: [2a0db5f7653b3576c430f8821654f365aaa7f178] struct filen=
ame: saner handling of long names

--h6/Gi/PuZHhd8q9O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlmZUEACgkQJNaLcl1U
h9DQJwf8C3NcfFjcKFdWBuMA4jOVDK6FwY5YvdFlveZWhZCdctBlga9TxZ4Q9Wxs
iJ/r3Prax8XJXW9/BvP0tHDIhSRzvmw/PAoG2UVe0AaxJlzZp6hU+Sf1n7WoMxKS
BlDtN3pGzSaBEq7TOND6BL9847Vep/5aiz/s8J9mNY20+pZWCNgTWRlQEDyYBh3a
bqj9TLWgurThIDLM5vqEcdU9T2X6YP7kweqvkWHjQ24RYJufxJzm8sn3x9nwbQ2D
Zxe3CBvM8xHKv9Asnbx9zqYohhTZLvpFnotCNvJ9R2FHuNTyzjqcBX6U3OOSgigI
NbWV6UL/M8VpF9OzzfdjB4VL8iAy7Q==
=zE1W
-----END PGP SIGNATURE-----

--h6/Gi/PuZHhd8q9O--

